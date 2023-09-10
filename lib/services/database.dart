import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/gmodel.dart';
import '../models/user.dart';
import 'package:fontcontri/models/Expense.dart';
class Database{
  String? uid="";
  Database({this.uid});
  final CollectionReference nish = FirebaseFirestore.instance.collection('userdata');
  Future takeinfo(String name) async{
    List<String> groups = [];
    return await nish.doc(uid).set(
      {
        'name' : name,
        'groupIDs' : groups,
      }
    );
  }

  UserData _userdatafromss(DocumentSnapshot snapshot){
    return UserData(
        uid: uid!,
        name: snapshot.get('name'),
        groupIDs: List<String>.from(snapshot.get('groupIDs') ?? []),
    );
  }


  // stream for user data model for settings disp
  Stream<UserData> get userdata{
    return nish.doc(uid).snapshots()
        .map(_userdatafromss);
  }


  //create group function
  Future Creategroup(String gname, String uid)async{
    List<String> members = [];
    List<String> groups = [];
    try{
      members.add(uid);
      DocumentReference _docref = await FirebaseFirestore.instance.collection('groups').add(
        {
          'name' : gname,
          'members' : members
        }
      );
      // making a subcollection reference for storing the scores of members
      CollectionReference _memsub = FirebaseFirestore.instance.collection('groups').doc(_docref.id).collection('members');
      await _memsub.doc(uid).set({
        'score' : 0.0,
      });
      //adding gids to user collection under uids
      groups.add(_docref.id);
      nish.doc(uid).update({
        'groupIDs' : FieldValue.arrayUnion(groups),
      });
      return 1;
    }catch(e){
      print(e.toString());
      return null;
    }
  }


  //join group function
  Future Joingroup(String groupID, String uid)async{
    List<String> members = [];
    List<String> groups = [];
    try{
      members.add(uid);
      await FirebaseFirestore.instance.collection('groups').doc(groupID).update(
          {
            'members' : FieldValue.arrayUnion(members)
          }
      );
      CollectionReference _memscores = FirebaseFirestore.instance.collection('groups').doc(groupID).collection('members');
      await _memscores.doc(uid).set({
        'score' : 0.0,
      });
      groups.add(groupID);
      nish.doc(uid).update({
        'groupIDs': FieldValue.arrayUnion(groups),
      });
      return 1;
    }catch(e){
      print(e.toString());
      return null;
    }
  }


  //Stream to get scores of all the users in the group
  Stream<List<Map<String, dynamic>>> scorefetch(String gid) {
    return FirebaseFirestore.instance.collection('groups')
        .doc(gid)
        .collection('members')
        .snapshots()
      .asyncMap((snapshot) async{
      final ssmemscores = await Future.wait(snapshot.docs.map((doc) async {
        final uid = doc.id;
        final score = doc.get('score') ?? 0;
        final userdata = await nish.doc(uid).get();
        final name = userdata.get('name');
        return {
          'uid': uid,
          'score': score,
          'name': name,
        };
      }),
      );
      return ssmemscores;
    });
  }


  //function to update scores in DB;
  Future updatescores({required String uid, required String groupID, required double contri}) async{
    try{
      DocumentSnapshot scoress = await FirebaseFirestore.instance.collection('groups')
          .doc(groupID)
          .collection('members')
          .doc(uid).get();
      if(scoress.exists){
        Map<String, dynamic> scoressdata = scoress.data() as Map<String, dynamic>;
        double existingscore = (scoressdata['score'] ?? 0).toDouble();
        double newscore = existingscore + contri;
        await FirebaseFirestore.instance.collection('groups')
            .doc(groupID)
            .collection('members')
            .doc(uid).update(
            {
              'score' : newscore,
            }
        );
      }
    }catch (e){
      print(e);
    }
  }


  //Stream to provide group names of only the groups that user is in
  Stream<List<gmodel>> groupStream(List<String> groupIDs) {
    if (groupIDs.isEmpty) {
      // If the groupIDs list is empty, return an empty stream
      return Stream.value([]);
    } else {
      return FirebaseFirestore.instance
          .collection('groups')
          .where(FieldPath.documentId, whereIn: groupIDs)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          String gid = doc.id;
          String gname = doc.get('name');
          List<String> members = List<String>.from(doc.get('members'));

          return gmodel(gid: gid, gname: gname, members: members);
        }).toList();
      });
    }
  }


  //function to add expense
  Future Addexpense(
      {required String groupID, required double amount, required String description, required String giver, required String giveruid, required String month, required String date, required String time}) async{
    final CollectionReference expensecollection = FirebaseFirestore.instance.collection('groups').doc(groupID).collection('expenses');
    await expensecollection.add({
      'amount' : amount,
      'description' : description,
      'giver' : giver,
      'giveruid' : giveruid,
      'month' : month,
      'date' : date,
      'time' : time,
      'creationtime': FieldValue.serverTimestamp(),
    });
  }


  //Stream to provide expense data found from ss
  Stream<List<expensemodel>> expsensestream(String groupID) {
    final CollectionReference expensecollection =
    FirebaseFirestore.instance.collection('groups').doc(groupID).collection('expenses');
    final Query query = expensecollection.orderBy('creationtime', descending: true);
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return expensemodel(
          amount: doc.get('amount'),
          description: doc.get('description'),
          giver: doc.get('giver'),
          giveruid: doc.get('giveruid'),
          month: doc.get('month'),
          date: doc.get('date'),
          time: doc.get('time'),
        );
      }).toList();
    });
  }
}


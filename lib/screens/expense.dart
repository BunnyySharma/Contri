import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fontcontri/services/calculations.dart';
import '../models/gmodel.dart';
import '../models/user.dart';
import '../services/database.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';


class expense extends StatefulWidget {
  final gmodel group;
  const expense({super.key, required this.group});

  @override
  State<expense> createState() => _expenseState(group: group);
}

class _expenseState extends State<expense> {
  final gmodel group;
  _expenseState({required this.group});
  final _formkey= GlobalKey<FormState>();
  String description ='';
  double amount = 0;
  String tempgiver='';
  String selected = 'Select name';
  bool isselected = false;
  Database _db = Database();
  @override
  Widget build(BuildContext context) {
    final prouser = Provider.of<MyUser?>(context);
    DateTime now = DateTime.now();
    String month = DateFormat('MMM').format(now);
    String date = DateFormat('dd').format(now);
    String time = DateFormat.jm().format(now);
    String giver = isselected? tempgiver : prouser!.uid;
        return StreamBuilder<UserData>(
          stream: Database(uid: prouser!.uid).userdata,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              UserData? user = snapshot.data;
              String username = user!.name;
              return Scaffold(
                backgroundColor: Color(0xFF004C4e),
                appBar: AppBar(
                  backgroundColor: Colors.black26,
                  elevation: 0,
                  title: Text(
                    "Add Expense",
                    style: TextStyle(
                      color: Color(0xFFD5FFFF),
                    ),
                  ),
                  centerTitle: true,
                ),
                body: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 20), //Seperation from App bar
                      Center(
                        child: Container(
                          width: 200,
                          child: TextFormField(
                            validator: (val)=> val!.isEmpty ? 'Please Enter amount to proceed' : null,
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                            onChanged: (val) {
                              double intval = double.parse(val) ?? 0;
                              setState(() => amount = intval);
                            },
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFD5FFFF),
                            ),
                            decoration: InputDecoration(
                              errorStyle: TextStyle(color: Colors.red[400]),
                                floatingLabelBehavior: FloatingLabelBehavior
                                    .never,
                                label: Center(
                                  child: Text("Enter Amount"),
                                ),
                                prefixText: "₹",
                                prefixStyle: TextStyle(
                                  color: Color(0xFFD5FFFF),
                                  fontSize: 17,
                                ),
                                alignLabelWithHint: true,
                                labelStyle: TextStyle(
                                  color: Colors.grey[400],
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1.8,
                                      color: Color(0x8A242526),
                                    )
                                )
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: 200,
                          child: TextFormField(
                            validator: (val)=> val!.isEmpty ? 'Please Enter a Description' : null,
                            onChanged: (val)=> setState(()=> description = val),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFD5FFFF),
                            ),
                            decoration: InputDecoration(
                                errorStyle: TextStyle(color: Colors.red[400]),
                                floatingLabelBehavior: FloatingLabelBehavior
                                    .never,
                                label: Center(
                                  child: Text("Enter Description"),
                                ),
                                alignLabelWithHint: true,
                                labelStyle: TextStyle(
                                  color: Colors.grey[400],
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1.8,
                                      color: Color(0x8A242526),
                                    )
                                )
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Contri given by",
                            style: TextStyle(
                              color: Color(0xFFD5FFFF),
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            child: ElevatedButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    backgroundColor: Color(0xFF272640),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    context: context,
                                    builder: (context) {
                                      return SizedBox(
                                        height: 200,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 7),
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              physics: BouncingScrollPhysics(),
                                              itemCount: group.members.length,
                                              itemBuilder: (context, index) {
                                                return StreamBuilder<UserData>(
                                                    stream: Database(
                                                        uid: group.members[index])
                                                        .userdata,
                                                    builder: (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        UserData? ud = snapshot
                                                            .data;
                                                        return Card(
                                                          child: ListTile(
                                                            onTap: () async {
                                                              setState(() {
                                                                selected = ud!.name;
                                                                isselected = true;
                                                                tempgiver = group.members[index];
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            title: Text(
                                                              "${ud?.name}",
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFFD5FFFF),
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                          ),
                                                          color: Color(
                                                              0xFF272640),
                                                          elevation: 0,
                                                        );
                                                      } else {
                                                        return CircularProgressIndicator();
                                                      }
                                                    }
                                                );
                                              }
                                          ),
                                        ),
                                      );
                                    }
                                );
                              },
                              child: Text(
                                isselected ? selected : username,
                                style: TextStyle(
                                  color: Color(0xFFD5FFFF),
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    Color(0xFF272640)),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20,),
                      ElevatedButton(
                        onPressed: () async {
                        if(_formkey.currentState!.validate()){
                          double contri = await calculations().contri(
                              amount: amount, members: group.members);
                          UserData userData = await Database(uid: giver)
                              .userdata.first;
                          String givername = userData.name;
                          for (String member in group.members) {
                            if(giver == member){
                              double genuinecontri = amount - contri;
                              await _db.updatescores(uid: member, groupID: group.gid, contri: genuinecontri);
                            }
                            else{
                              double contriwsign = - contri;
                              await _db.updatescores(uid: member, groupID: group.gid, contri: contriwsign);
                            }
                          }
                          await _db.Addexpense(groupID: group.gid, amount: amount, description: description, giver: givername,giveruid: giver, month: month, date: date, time: time);
                          Navigator.pop(context);
                          }
                        },
                        child: Text(
                          "Done",
                          style: TextStyle(
                            color: Color(0xFFD5FFFF),
                            fontSize: 20,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFF272640)),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }else{
              return CircularProgressIndicator();
            }
          }
        );
  }
}

import 'package:flutter/material.dart';
import 'package:fontcontri/models/gmodel.dart';
import 'package:fontcontri/screens/expense.dart';
import 'package:fontcontri/screens/settleup.dart';
import 'package:fontcontri/services/database.dart';
import 'package:fontcontri/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../models/Expense.dart';
import '../models/user.dart';
import 'package:fontcontri/models/tmodel.dart';
import 'package:fontcontri/services/simpletransactions.dart';
class groupscreen extends StatefulWidget {
  final gmodel group;
  const groupscreen({super.key, required this.group});

  @override
  State<groupscreen> createState() => _groupscreenState(group: group);
}

class _groupscreenState extends State<groupscreen> {
  final gmodel group;
  _groupscreenState({required this.group});
  @override
  Widget build(BuildContext context) {
    final prouser = Provider.of<MyUser?>(context);
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: Database().scorefetch(group.gid),
      builder: (context, snapshot) {
        if (snapshot.hasData){
          Map<String, double> balances = {};
          for (var userData in snapshot.data!) {
            String uid = userData['uid'];
            double score = userData['score'];
            balances[uid] = score;
          }
          double userScore = balances[prouser!.uid] ?? 0.0;
          List<transactionmodel> transactions = simplify(balances);
          return Scaffold(
            backgroundColor: Color(0xFF272640),
            appBar: AppBar(
              backgroundColor: Color(0xFF272640),
              elevation: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    onPressed: () async{
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
                                child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              Clipboard.setData(ClipboardData(text: group.gid));
                                            },
                                            icon: Icon(
                                                Icons.copy,
                                              color: Color(0xFFD5FFFF),
                                            )
                                        ),
                                        SelectableText(
                                          "${group.gid}",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xFFD5FFFF),
                                          ),
                                        ),
                                      ],
                                    )
                                ),
                              ),
                            );
                          }
                      );
                    },
                    child: Text(
                      "Group ID",
                      style: TextStyle(
                        color: Color(0xFF499799),
                      ),
                    ),
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                    ),
                  )
                ],
              ),
            ),
            body: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "${group.gname}",
                        style: TextStyle(
                          color: Color(0xFFD5FFFF),
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10,40,0,0),
                  child: Divider(
                    height: 0,
                    color: Color(0xFF313050),
                    thickness: 0.9,
                  ),
                ),
                Column(
                  children: <Widget>[
                    if (userScore == 0.0)
                      Container(
                      height:155,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check,
                              color: Color(0x8AD5FFFF),
                              size: 27,
                            ),
                            SizedBox(width: 3),
                            Text(
                              'No Contri',
                              style: TextStyle(
                                color: Color(0x8AD5FFFF),
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if(userScore != 0.0)
                    Container(
                      height: 155,
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: transactions.length,
                          itemBuilder: (context, index)  {
                            if (userScore == 0) {
                              return Container(
                                height:150,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check,
                                        color: Color(0x8AD5FFFF),
                                        size: 27,
                                      ),
                                      SizedBox(width: 3),
                                      Text(
                                        'No Contri',
                                        style: TextStyle(
                                          color: Color(0x8AD5FFFF),
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                              }else{
                              return Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Column(
                                  children: <Widget>[
                                    if (prouser?.uid == transactions[index].creditor)
                                      FutureBuilder(
                                        future:  Database(uid: transactions[index].debtor).userdata.first,
                                        builder: (context, snapshot){
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                          } else if (snapshot.hasError) {
                                          return Text('Error: ${snapshot.error}');
                                          } else if (snapshot.hasData) {
                                            UserData? debdata = snapshot.data;
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 8.0),
                                                  child: Text(
                                                    debdata!.name,
                                                    style: TextStyle(
                                                      color: Color(0xFFD5FFFF),
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                      "Owes you: ",
                                                      style: TextStyle(
                                                        color: Color(0x8AD5FFFF),
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    Text(
                                                      "₹${transactions[index]
                                                          .amount}",
                                                      style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 15,
                                                      ),
                                                    )
                                                  ],
                                                  ),
                                              ],
                                            );
                                            }else{
                                            return Text('Error: ${snapshot.error}');
                                          }
                                         },
                                      ),
                                    if (prouser?.uid == transactions[index].debtor)
                                      FutureBuilder(
                                        future:  Database(uid: transactions[index].creditor).userdata.first,
                                        builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                        } else if (snapshot.hasData) {
                                          UserData? creddata = snapshot.data;
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 8.0),
                                                child: Text(
                                                  creddata!.name,
                                                  style: TextStyle(
                                                    color: Color(0xFFD5FFFF),
                                                    fontSize: 17,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "You owe: ",
                                                    style: TextStyle(
                                                      color: Color(0x8AD5FFFF),
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  Text(
                                                    "₹${transactions[index]
                                                        .amount}",
                                                    style: TextStyle(
                                                      color: Colors.red[400],
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        }else{
                                          return Text('Error: ${snapshot.error}');
                                        }
                                        }
                                      ),
                                  ],
                                ),
                              );
                            }
                          } //itemBuilder
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0, left: 20),
                                child: Text(
                                  "Expenses",
                                  style: TextStyle(
                                    color: Color(0x8AD5FFFF),
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 9.0),
                                child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => settle(group: group),
                                        ),
                                      );
                                    },
                                    child: Text(
                                        'Settle up?',
                                      style: TextStyle(
                                        color: Color(0xFF499799),
                                      ),
                                    ),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Divider(
                              height: 0,
                              color: Color(0xFF272640),
                              thickness: 0.9,
                            ),
                          ),
                          StreamBuilder<List<expensemodel>>(
                            stream: Database().expsensestream(group.gid),
                            builder: (context, snapshot) {
                              if(snapshot.hasData){
                                List<expensemodel> expenselist = snapshot.data!;
                                if(expenselist.length != 0){
                                  return Expanded(
                                    child: SizedBox(
                                      height: 200,
                                      child: ListView.builder(
                                          itemCount: expenselist.length,
                                          itemBuilder: (context, index){
                                            return ListTile(
                                              title: Text(
                                                expenselist[index].description,
                                                style: TextStyle(
                                                  color: Color(0xFFD5FFFF),
                                                  fontSize: 17,
                                                ),
                                              ),
                                              subtitle: Row(
                                                children: <Widget>[
                                                  Text(
                                                      expenselist[index].giveruid == prouser!.uid ? "You" : expenselist[index].giver,
                                                      style: TextStyle(
                                                        color: Color(0x8AD5FFFF),
                                                        fontSize: 15,
                                                      )
                                                  ),
                                                  SizedBox(width: 3),
                                                  Text(
                                                      "paid",
                                                      style: TextStyle(
                                                        color: Color(0x8AD5FFFF),
                                                        fontSize: 15,
                                                      )
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    "₹${expenselist[index].amount}",
                                                    style: TextStyle(
                                                      color: expenselist[index].giveruid == prouser!.uid ? Colors.red[400
                                                      ] : Colors.green,
                                                      fontSize: 15,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              trailing: Text(
                                                expenselist[index].time,
                                                style: TextStyle(
                                                  color: Color(0xFFD5FFFF),
                                                ),
                                              ),
                                              leading: Container(
                                                height: 40,
                                                width: 40,
                                                padding: EdgeInsets.all(2.5),
                                                child: Column(
                                                  children: <Widget>[
                                                    Text(
                                                      expenselist[index].date,
                                                      style: TextStyle(
                                                        color: Color(0xFFD5FFFF),
                                                      ),
                                                    ),
                                                    Text(
                                                      expenselist[index].month,
                                                      style: TextStyle(
                                                        color: Color(0xFFD5FFFF),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                color: Color(0x61499799),
                                              ),
                                            );
                                          }
                                      ),
                                    ),
                                  );
                                }else{
                                  return Expanded(
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Expanded(
                                              child: SizedBox(),
                                              flex:1,
                                          ),
                                          Expanded(
                                            flex:1,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                    Icons.currency_rupee,
                                                  color:  Color(0x8AD5FFFF),
                                                  size: 26,
                                                ),
                                                Text(
                                                  'Make your first Expense!',
                                                  style: TextStyle(
                                                    color: Color(0x8AD5FFFF),
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                              flex:3,
                                              child: SizedBox()
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              }else{
                                return CircularProgressIndicator();
                              }
                            }
                          )
                        ],
                      ),
                      color: Color(0x8A313050),
                    ),
                  ),
                )
              ],
            ),


            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => expense(group: group),
                  ),
                );
              },
              child: Icon(
                Icons.add,
                color: Colors.black,
              ),
              backgroundColor: Color(0xFF499799),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          );
        }else{
          return Loading();
        }
      }
    );
  }
}

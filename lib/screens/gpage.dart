import 'package:flutter/material.dart';
import 'package:fontcontri/services/people.dart';
import 'package:intl/intl.dart';
class gpage extends StatefulWidget {
  const gpage({super.key});

  @override
  State<gpage> createState() => _gpageState();
}

class _gpageState extends State<gpage> {
  peopleinfo ins = peopleinfo();
  @override
  void initState() {
    super.initState();
    ins.add();
  }
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String month = DateFormat('MMM').format(now);
    String Date = DateFormat('dd').format(now);
    String time = DateFormat.jm().format(now);
    return Scaffold(
      backgroundColor: Color(0xFF272640),
      appBar: AppBar(
        backgroundColor: Color(0xFF272640),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextButton(
              onPressed: () async{},
              child: Text(
                "Add Friends",
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
                  "My New Group",
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
              Container(
                height: 155,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: ins.total.length,
                    itemBuilder: (context, index){
                    final person = ins.total[index];
                    return Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              "${person.name}",
                              style: TextStyle(
                                color: Color(0xFFD5FFFF),
                                fontSize: 17,
                              ),
                            ),
                          ),
                          if (person.owes_you != 0)
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
                                  "₹${person.owes_you}",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 15,
                                  ),
                                )
                              ],
                            ),
                          if (person.you_owe != 0)
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
                                  "₹${person.you_owe}",
                                  style: TextStyle(
                                    color: Colors.red[400],
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    );
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Expenses",
                            style: TextStyle(
                              color: Color(0x8AD5FFFF),
                              fontSize: 25,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    ListTile(
                      title: Text(
                          "Food",
                        style: TextStyle(
                          color: Color(0xFFD5FFFF),
                          fontSize: 17,
                        ),
                      ),
                      subtitle: Row(
                        children: <Widget>[
                          Text(
                              "You Paid",
                            style: TextStyle(
                              color: Color(0x8AD5FFFF),
                              fontSize: 15,
                            )
                          ),
                          SizedBox(width: 5),
                          Text(
                              "₹600",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                      trailing: Text(
                          time,
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
                                  Date,
                            style: TextStyle(
                              color: Color(0xFFD5FFFF),
                              ),
                            ),
                              Text(
                                  month,
                                style: TextStyle(
                                  color: Color(0xFFD5FFFF),
                                ),
                              ),
                            ],
                          ),
                        color: Color(0x61499799),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "Miscellaneous",
                        style: TextStyle(
                          color: Color(0xFFD5FFFF),
                          fontSize: 17,
                        ),
                      ),
                      subtitle: Row(
                        children: <Widget>[
                          Text(
                              "Aditya Paid You",
                              style: TextStyle(
                                color: Color(0x8AD5FFFF),
                                fontSize: 15,
                              )
                          ),
                          SizedBox(width: 5),
                          Text(
                            "₹100",
                            style: TextStyle(
                              color: Colors.red[400
                              ],
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                      trailing: Text(
                        "5:02 PM",
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
                              Date,
                              style: TextStyle(
                                color: Color(0xFFD5FFFF),
                              ),
                            ),
                            Text(
                              month,
                              style: TextStyle(
                                color: Color(0xFFD5FFFF),
                              ),
                            ),
                          ],
                        ),
                        color: Color(0x61499799),
                      ),
                    ),
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
          Navigator.pushNamed(context, "/exp");
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
  }
}

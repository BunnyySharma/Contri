import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/gmodel.dart';
import '../models/user.dart';
import '../services/database.dart';

class settle extends StatefulWidget {
  final gmodel group;
  const settle({super.key, required this.group});

  @override
  State<settle> createState() => _settleState(group: group);
}

class _settleState extends State<settle> {
  final gmodel group;
  _settleState({required this.group});
  @override
  final _formkey= GlobalKey<FormState>();
  String description ='';
  double amount = 0;
  String tempgiver='';
  String selected = 'Select name';
  bool isselected = false;
  Database _db = Database();
  String issue = '';
  @override
  Widget build(BuildContext context) {
    String username = 'Select user';
    final prouser = Provider.of<MyUser?>(context);
    String giver = prouser!.uid;
    String reciever = isselected? tempgiver : '';
    return StreamBuilder<UserData>(
        stream: Database(uid: prouser!.uid).userdata,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              backgroundColor: Color(0xFF004C4e),
              appBar: AppBar(
                backgroundColor: Colors.black26,
                elevation: 0,
                title: Text(
                  "Settle Up",
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
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Contri given to",
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
                                              if (group.members[index] != prouser?.uid) {
                                                return StreamBuilder<UserData>(
                                                    stream: Database(uid: group.members[index]).userdata,
                                                    builder: (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        UserData? ud = snapshot.data;
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
                                              }else{
                                                return SizedBox.shrink();
                                              }
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
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        issue,
                        style: TextStyle(
                          color: Colors.red[600],
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    ElevatedButton(
                      onPressed: () async {
                        if(_formkey.currentState!.validate()){
                          if(isselected == true) {
                            print(reciever);
                            print(giver);
                            print(amount);
                            double recieveramount = - amount;
                            await _db.updatescores(uid: giver, groupID: group.gid, contri: amount);
                            await _db.updatescores(uid: reciever, groupID: group.gid, contri: recieveramount);
                            Navigator.pop(context);
                          }else{
                            setState(()=> issue = 'Please select a user');
                          }
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
                    ),
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

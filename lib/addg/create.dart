import 'package:flutter/material.dart';
import 'package:fontcontri/services/database.dart';
import 'package:provider/provider.dart';
import 'package:fontcontri/models/user.dart';
import 'package:fontcontri/shared/loading.dart';

class create extends StatefulWidget {
  final Function view;
  const create({super.key, required this.view});

  @override
  State<create> createState() => _createState();
}

class _createState extends State<create> {
  String issue = '';
  bool loading = false;
  Database _db = Database();
  final _formkey= GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final prouser = Provider.of<MyUser?>(context);
    String groupID = "";
    String name="";
    String value="";
    return loading ? Loading() : Scaffold(
      backgroundColor: Color(0xFF272640),
      appBar: AppBar(
        backgroundColor: Color(0xFF272640),
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: <Widget>[
          TextButton(
              onPressed: () {
                widget.view();
              },
              child: Text(
                "Join a group?",
                style: TextStyle(
                  color: Color(0xFF499799),
                  fontSize: 14,
                ),
              )
          )
        ],
      ),
      body: Form(
        key: _formkey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Create a New Group!",
                  style: TextStyle(
                    color: Color(0xFFD5FFFF),
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),


              // JOIN GROUP FIELD
              SizedBox(height: 30,),
              TextFormField(
                validator: (val)=>val!.isEmpty ? 'Group name not entered': null,
                onChanged: (val){
                  value = val;
                },
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFFD5FFFF),
                ),
                decoration: InputDecoration(
                  hintText: "Group name",
                  hintStyle: TextStyle(
                    color: Color(0x8AD5FFFF),
                  ),
                  prefixIcon: Icon(
                    Icons.tag_rounded,
                    color: Color(0x8AD5FFFF),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Color(0x8A313050),
                ),
              ),


              //cross tick buttons
              Padding(
                padding: const EdgeInsets.fromLTRB(12,8,12,0),
                child: Divider(
                  height: 20,
                  color: Colors.grey[500],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: Color(0xFF499799),
                        size: 30,
                      )
                  ),
                  IconButton(
                      onPressed: () async {
                        setState(() {
                          name= value;
                          loading = true;
                        });
                        if(_formkey.currentState!.validate()){
                          dynamic result = await _db.Creategroup(name, prouser!.uid);
                          if(result == 1){
                            Navigator.pop(context);
                            setState(() {
                              loading = false;
                            });
                          }else{
                            setState(() {
                              issue = "Couldn't Create a group, please try again";
                              loading = false;
                            });
                          }
                        }
                        setState(() => loading = false);
                      },
                      icon: Icon(
                        Icons.check,
                        color: Color(0xFF499799),
                        size: 30,
                      )
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12,0,12,0),
                child: Divider(
                  height: 20,
                  color: Colors.grey[500],
                ),
              ),
              SizedBox(height: 12,),
              Text(
                issue,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

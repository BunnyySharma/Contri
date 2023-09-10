import 'package:flutter/material.dart';
import 'package:fontcontri/models/user.dart';
import 'package:fontcontri/services/auth.dart';
import 'package:fontcontri/services/database.dart';
import 'package:fontcontri/shared/loading.dart';
import 'package:provider/provider.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  final Authservice _auth = Authservice();
  @override
  Widget build(BuildContext context) {
    final prouser = Provider.of<MyUser?>(context);
    return StreamBuilder<UserData>(
      stream: Database(uid: prouser?.uid).userdata,
      builder: (context, snapshot) {
        if (snapshot.hasData){
          UserData? ud = snapshot.data;
          return Scaffold(
              backgroundColor: Color(0xFF272640),
              appBar: AppBar(
                backgroundColor: Color(0xFF272640),
                elevation: 0,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: TextButton(
                        onPressed: (){
                          _auth.logout();
                        },
                        child: Text(
                          "log out",
                          style: TextStyle(
                            color: Color(0xFF499799),
                          ),
                        )
                    ),
                  )
                ],
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Logged in as",
                        style: TextStyle(
                          color: Color(0x8AD5FFFF),
                          fontSize: 45,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 30,),
                      Container(
                          height:50,

                          padding: EdgeInsets.fromLTRB(20,10,10,10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    ud!.name,
                                    style: TextStyle(
                                      color: Color(0xFFD5FFFF),
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Color(0x8A313050),
                            borderRadius: BorderRadius.circular(13),
                          )
                      ),
                      SizedBox(height: 15,),
                      Container(
                        height: 50,
                          padding: EdgeInsets.fromLTRB(20,10,10,10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                      Icons.mail_outline_rounded,
                                    color: Color(0x8AD5FFFF),
                                  ),
                                  SizedBox(width: 10,),
                                  Text(
                                    "${prouser?.email}",
                                    style: TextStyle(
                                      color: Color(0xFFD5FFFF),
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Color(0x8A313050),
                            borderRadius: BorderRadius.circular(13),
                          )
                      ),
                    ],
                  ),
                ),
              )
          );
        }else{
          return Loading();
        }
      }
    );
  }
}

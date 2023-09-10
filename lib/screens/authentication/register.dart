import 'package:flutter/material.dart';
import 'package:fontcontri/services/database.dart';

import '../../services/auth.dart';
import '../../shared/loading.dart';

class signup extends StatefulWidget {
  final Function view;
  const signup({super.key, required this.view});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  final Authservice _auth = Authservice();
  final _formkey= GlobalKey<FormState>();
  bool obtext = true;
  String issue = "";
  String email="";
  String pass="";
  String name = "";
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
        backgroundColor: Color(0xFF272640),
        appBar: AppBar(
          backgroundColor: Color(0xFF272640),
          elevation: 0,
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  widget.view();
                },
                child: Text(
                  "Sign in?",
                  style: TextStyle(
                    color: Color(0xFFD5FFFF),
                    fontSize: 16,
                  ),
                )
            )
          ],
        ),
        body: Form(
          key: _formkey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Welcome",
                    style: TextStyle(
                      color: Color(0xFFD5FFFF),
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.6,
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Sign up to continue",
                    style: TextStyle(
                      color: Color(0xFFD5FFFF),
                      letterSpacing: 0.5,
                      fontSize: 17,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                TextFormField(
                  validator: (val)=>val!.isEmpty ? 'Name not entered': null,
                  onChanged: (val){
                    setState(
                            () => name = val
                    );
                  },
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFD5FFFF),
                  ),
                  decoration: InputDecoration(
                    hintText: "Name",
                    hintStyle: TextStyle(
                      color: Color(0x8AD5FFFF),
                    ),
                    prefixIcon: Icon(
                      Icons.person_outline_rounded,
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
                SizedBox(height: 10,),
                TextFormField(
                  validator: (val)=>val!.isEmpty ? 'Email not entered': null,
                  onChanged: (val){
                    setState(
                            () => email = val
                    );
                  },
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFD5FFFF),
                  ),
                  decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(
                      color: Color(0x8AD5FFFF),
                    ),
                    prefixIcon: Icon(
                      Icons.mail_outline_rounded,
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
                SizedBox(height: 10,),
                TextFormField(
                  validator: (val)=>val!.length < 6? 'Password needs to be above 6 digits': null,
                  onChanged: (val){
                    setState(
                            () => pass = val
                    );
                  },
                  obscureText: obtext,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFD5FFFF),
                  ),
                  decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(
                      color: Color(0x8AD5FFFF),
                    ),
                    prefixIcon: Icon(
                      Icons.lock_rounded,
                      color: Color(0x8AD5FFFF),
                    ),
                    suffixIcon: IconButton(
                        onPressed: (){setState(()=> obtext = !obtext);},
                        icon:  Icon(
                          obtext ? Icons.visibility_off : Icons.visibility,
                          color: Color(0x8AD5FFFF),
                        )
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Color(0x8A313050),
                  ),
                ),
                SizedBox(height: 30,),
                ElevatedButton(
                    onPressed: () async{
                      setState(() {
                        loading = true;
                      });
                      if(_formkey.currentState!.validate()){
                        dynamic result = await _auth.registerwithemail(email, pass);
                        await Database(uid: result.uid).takeinfo(name);
                        if(result == null){
                          setState(() {
                            issue = "Invalid email or password";
                            loading = false;
                          });
                        }
                        print(issue);
                      }else{
                        setState(() {
                          loading = false;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF004C4e),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Lets Go!",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    )
                ),
              ],
            ),
          ),
        )
    );
  }
}

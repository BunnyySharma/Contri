import 'package:flutter/material.dart';
import 'package:fontcontri/screens/authentication/register.dart';
import 'package:fontcontri/screens/authentication/signin.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showsignin = true;
  void view(){
    setState(() {
      showsignin = !showsignin;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showsignin){
      return signin(view: view,);
    }
    else{
      return signup(view: view,);
    }
  }
}

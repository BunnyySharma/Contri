import 'package:flutter/material.dart';
import 'package:fontcontri/screens/authentication/authenticate.dart';
import 'package:fontcontri/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:fontcontri/models/user.dart';

class wrapper extends StatefulWidget {
  const wrapper({super.key});

  @override
  State<wrapper> createState() => _wrapperState();
}

class _wrapperState extends State<wrapper> {
  @override
  Widget build(BuildContext context) {
    final prouser = Provider.of<MyUser?>(context);
    if (prouser == null){
      return Authenticate();
    }
    else{
      return home();
    }
  }
}

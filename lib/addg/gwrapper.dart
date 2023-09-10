import 'package:flutter/material.dart';
import 'package:fontcontri/addg/add.dart';
import 'package:fontcontri/addg/create.dart';


class gwrapper extends StatefulWidget {
  const gwrapper({super.key});

  @override
  State<gwrapper> createState() => _gwrapperState();
}

class _gwrapperState extends State<gwrapper> {
  bool showjoin = true;
  void view(){
    setState(() {
      showjoin = !showjoin;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showjoin){
      return addgroup(view: view,);
    }
    else{
      return create(view: view,);
    }
  }
}

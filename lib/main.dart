import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fontcontri/addg/gwrapper.dart';
import 'package:fontcontri/models/user.dart';
import 'package:fontcontri/addg/add.dart';
import 'package:fontcontri/screens/authentication/wrapper.dart';
import 'package:fontcontri/screens/expense.dart';
import 'package:fontcontri/screens/gpage.dart';
import 'package:fontcontri/screens/groupscreen.dart';
import 'package:fontcontri/services/auth.dart';
import 'package:provider/provider.dart';


Future<void> main() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser?>.value(
      value: Authservice().userstream,
      initialData: null,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: {
          "/" : (context) => wrapper(),
          "/gp" : (context) => gpage(),
          "/ga" : (context) => gwrapper(),
        },
      ),
    );
  }
}


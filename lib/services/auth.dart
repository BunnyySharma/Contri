import 'package:firebase_auth/firebase_auth.dart';
import 'package:fontcontri/models/user.dart';

class Authservice{
  final FirebaseAuth _auth = FirebaseAuth.instance;


  //initializing my own user model
  MyUser? _user(User? user){
    return user != null ?MyUser(uid: user.uid, email: user.email) : null;
  }


  //stream for auth changes
  Stream<MyUser?> get userstream{
      return _auth.authStateChanges().map((User? user) => _user(user));
  }


  //register using email and password
  Future registerwithemail(String email, String pass) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: pass);
      User? user = result.user;
      return _user(user);
    }catch (e){
      print(e.toString());
      return null;
    }
  }

  
  //sign in using email and password
  Future signinwithemail(String email , String pass) async{
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: pass);
      User? user= result.user;
      return _user(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }


  //sign in using google


  //logout
  Future logout() async{
    try{
      return _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}
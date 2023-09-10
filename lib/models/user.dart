class MyUser{
  String uid;
  String? email;
  MyUser({required this.uid, this.email});
}
class UserData{
  String name;
  String uid;
  List<String>?groupIDs = [];
  UserData({required this.name, required this.uid, this.groupIDs});
}
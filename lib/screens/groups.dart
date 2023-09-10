import 'package:flutter/material.dart';
import 'package:fontcontri/screens/groupscreen.dart';
import 'package:fontcontri/services/auth.dart';
import 'package:provider/provider.dart';
import '../models/gmodel.dart';
import '../models/user.dart';
import '../services/database.dart';
import '../shared/loading.dart';

class groups extends StatefulWidget {
  const groups({super.key});
  @override
  State<groups> createState() => _groupsState();
}

class _groupsState extends State<groups> {
  List<String> name = [];
  @override
  Widget build(BuildContext context) {
    final _auth = Authservice();
    final prouser = Provider.of<MyUser?>(context);
    return StreamBuilder<UserData>(
      stream: Database(uid: prouser?.uid).userdata,
      builder: (context, snapshot) {
        UserData? ud = snapshot.data;
        return StreamBuilder<List<gmodel>>(
          stream: Database().groupStream(ud?.groupIDs ?? []),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<gmodel>? gd = snapshot.data;
              // print('gd data = $gd');
              return Scaffold(
                  backgroundColor: Color(0xFF272640),
                  appBar: AppBar(
                    backgroundColor: Color(0xFF272640),
                    elevation: 0,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        // TextButton(onPressed: () async{await _auth.logout();}, child: Text("logout")),
                        TextButton(
                          onPressed: () async {
                            dynamic result = await Navigator.pushNamed(
                                context, "/ga");
                          },
                          child: Text(
                            "Add group",
                            style: TextStyle(
                              color: Color(0xFF499799),
                            ),
                          ),
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all<Color>(
                                Colors.transparent),
                          ),
                        )
                      ],
                    ),
                  ),
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 15, 0, 10),
                        child: Text(
                          "Your Groups",
                          style: TextStyle(
                            color: Color(0x8AD5FFFF),
                            fontSize: 25,
                          ),
                        ),
                      ),
                      gd != null && gd.isEmpty
                          ? Expanded(
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Color(0x8AD5FFFF),
                                    size: 30,
                                  ),
                                  Text(
                                    "Add a new group!",
                                    style: TextStyle(
                                        color: Color(0x8AD5FFFF),
                                        fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: gd?.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: <Widget>[
                                  Card(
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                groupscreen(group: gd![index]),
                                          ),
                                        );
                                      },
                                      title: Text(
                                        gd![index].gname,
                                        style: TextStyle(
                                          color: Color(0xFFD5FFFF),
                                          fontSize: 15,
                                        ),
                                      ),
                                      tileColor: Color(0xFF272640),
                                      trailing: Icon(
                                        Icons.navigate_next_rounded,
                                        color: Color(0xFFD5FFFF),
                                        size: 25,
                                      ),
                                    ),
                                    elevation: 0,
                                  )
                                ],
                              );
                            }
                        ),
                    ],
                  )
              );
            }else{
              return Loading();
            }
          }
        );
      }
    );
  }
}

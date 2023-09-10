import 'package:flutter/material.dart';
import 'package:fontcontri/screens/groups.dart';
import 'package:fontcontri/screens/profile.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  int currentindex =0;
  final screens = [
    groups(),
    profile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentindex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF004C4e),
        selectedItemColor: Color(0xFF499799),
        unselectedItemColor: Colors.black,
        showUnselectedLabels: false,
        currentIndex: currentindex,
          iconSize: 25,
          onTap: (index) {
          setState(() {
            currentindex = index;
          });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.groups),
              label: 'Groups'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
              label: 'Profile',
            ),
          ]
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:squirrel/src/screens/google_map_screen.dart';
import 'package:squirrel/src/screens/home_screen.dart';
import 'package:squirrel/src/screens/messages/message.dart';
import 'package:squirrel/src/screens/profile_page.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  int currentIndex = 0;
  Color backGroundColor = Colors.red;
  final screens = [
    HomeScreen(key: UniqueKey()),
    GoogleMapScreen(key: UniqueKey()),
    MessagesScreen(),
    ProfilePageUi()
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: Colors.white,
      currentIndex: currentIndex,
      onTap: (index) => setState(() => currentIndex = index),
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: backGroundColor),
        BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Maps',
            backgroundColor: backGroundColor),
        BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
            backgroundColor: backGroundColor),
        BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: backGroundColor),
      ],
    );
  }
}

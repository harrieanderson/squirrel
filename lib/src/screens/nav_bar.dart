import 'package:flutter/material.dart';
import 'package:squirrel/src/screens/messages/body.dart';
import 'package:squirrel/src/screens/profile_page.dart';

import 'google_map_screen.dart';
import 'home_screen.dart';
import 'messages/message.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentTab = 0;
  final List<Widget> screens = [
    HomeScreen(
      key: UniqueKey(),
    ),
    GoogleMapScreen(
      key: UniqueKey(),
    ),
    MessagesScreen(),
    ProfilePageUi(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = HomeScreen(key: UniqueKey());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
      ),
    );
  }
}

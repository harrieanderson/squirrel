import 'package:flutter/material.dart';
import 'package:squirrel/src/screens/profile_page.dart';

import 'google_map_screen.dart';
import 'home_screen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int currentIndex = 0;
  final List<Widget> screens = [
    HomeScreen(
      key: UniqueKey(),
    ),
    GoogleMapScreen(
      key: UniqueKey(),
    ),
    GoogleMapScreen(
      key: UniqueKey(),
    ),
    //MessagesScreen(),
    ProfilePageUi(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: screens,
        index: currentIndex,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildTabItem(
              index: 0,
              icon: Icon(
                Icons.home,
              ),
            ),
            buildTabItem(
              index: 1,
              icon: Icon(
                Icons.fmd_good_sharp,
              ),
            ),
            SizedBox(width: 60.0),
            buildTabItem(
              index: 2,
              icon: Icon(
                Icons.sms,
              ),
            ),
            buildTabItem(
              index: 3,
              icon: Icon(
                Icons.person,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTabItem({
    required int index,
    required Icon icon,
  }) {
    final isSelected = index == currentIndex;

    return IconTheme(
      data: IconThemeData(
        color: isSelected ? Colors.red : Colors.black,
      ),
      child: IconButton(
        icon: icon,
        onPressed: () => setState(() => currentIndex = index),
      ),
    );
  }
}
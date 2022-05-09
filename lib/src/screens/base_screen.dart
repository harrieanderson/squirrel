import 'package:flutter/material.dart';
import 'package:squirrel/src/screens/profile_page.dart';

import 'google_map_screen.dart';
import 'home_screen.dart';

class BaseScreen extends StatefulWidget {
  final FloatingActionButton? floatingActionButton;

  const BaseScreen({Key? key, this.floatingActionButton}) : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int currentIndex = 0;
  final List<Widget> screens = [
    Center(child: Text('Screen 1')),
    Center(child: Text('Screen 2')),
    Center(child: Text('Screen 3')),
    Center(child: Text('Screen 4')),
    // HomeScreen(
    //   key: UniqueKey(),
    // ),
    // GoogleMapScreen(
    //   key: UniqueKey(),
    // ),
    // GoogleMapScreen(
    //   key: UniqueKey(),
    // ),
    // //MessagesScreen(),
    // ProfilePageUi(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: screens,
        index: currentIndex,
      ),
      floatingActionButton: currentIndex == 0
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {},
            )
          : null,
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

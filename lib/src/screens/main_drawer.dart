import 'package:flutter/material.dart';
import 'package:squirrel/src/screens/google_map_screen.dart';
import 'package:squirrel/src/screens/home_screen.dart';
import 'package:squirrel/src/screens/messages/message.dart';
import 'package:squirrel/src/screens/profile_page.dart';

class MainDrawer extends StatefulWidget {
  final FloatingActionButton? floatingActionButton;
  const MainDrawer({Key? key, this.floatingActionButton}) : super(key: key);

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  int currentIndex = 0;
  final List<Widget> screens = [
    HomeScreen(key: UniqueKey()),
    GoogleMapScreen(key: UniqueKey()),
    MessagesScreen(),
    ProfilePageUi(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: screens,
        index: currentIndex,
      ),
      floatingActionButton: currentIndex == 0
          ? FloatingActionButton(child: Icon(Icons.add), onPressed: () {})
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
            buildTabItem(
              index: 3,
              icon: Icon(
                Icons.person,
              ),
            ),
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
          onPressed: () => setState(
                () => currentIndex = index,
              )),
    );
  }
}

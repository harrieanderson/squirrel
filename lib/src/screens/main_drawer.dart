import 'package:flutter/material.dart';
import 'package:squirrel/src/screens/google_map_screen.dart';
import 'package:squirrel/src/screens/home_screen.dart';
import 'package:squirrel/src/screens/messages/message.dart';
import 'package:squirrel/src/screens/profile_page.dart';

class MainDrawer extends StatefulWidget {
  final int index;
  final ValueChanged<int> onChangedTab;

  const MainDrawer({
    required this.index,
    required this.onChangedTab,
    Key? key,
  }) : super(key: key);

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    final placeholder = Opacity(
      opacity: 0,
      child: IconButton(icon: Icon(Icons.no_cell), onPressed: null),
    );
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 3,
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
          placeholder,
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
    );
  }

  Widget buildTabItem({
    required int index,
    required Icon icon,
  }) {
    final isSelected = index == widget.index;

    return IconTheme(
      data: IconThemeData(
        color: isSelected ? Colors.red : Colors.black,
      ),
      child: IconButton(
        icon: icon,
        onPressed: () => widget.onChangedTab(index),
      ),
    );
  }
}

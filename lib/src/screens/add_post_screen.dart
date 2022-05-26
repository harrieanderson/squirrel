import 'package:flutter/material.dart';
import 'package:squirrel/src/screens/home_screen.dart';
import 'package:squirrel/src/screens/navigation_screen.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NavigationScreen(),
              ),
            );
          },
        ),
        title: Text('Make A Post'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('Post'),
            // style: TextStyle(color: Colors.blue),
          ),
        ],
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(hintText: "What's happening?"),
          ),
        ],
      ),
    );
  }
}

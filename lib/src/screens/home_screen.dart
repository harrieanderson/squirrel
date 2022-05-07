import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:squirrel/models/usser_model.dart';
import 'package:squirrel/src/screens/login.dart';
import 'package:squirrel/src/screens/messages/message.dart';
import 'package:squirrel/src/screens/nav_bar.dart';
import 'package:squirrel/src/screens/profile_page.dart';
import './main_drawer.dart';
import 'google_map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({required Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser =
      UserModel(email: '', firstName: '', secondName: '', uid: '');

  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
      ),
      bottomNavigationBar: NavBar(),
      body: Center(
        child: Text(
          'Home screen',
          style: TextStyle(fontSize: 40),
        ),
      ),
      // bottomNavigationBar: NavBar(),
    );
  }
}

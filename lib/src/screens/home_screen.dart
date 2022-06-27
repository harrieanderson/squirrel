import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:squirrel/models/usser_model.dart';
import 'package:squirrel/src/screens/add_post_screen.dart';
import 'package:squirrel/src/screens/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel(
      email: '',
      firstName: '',
      secondName: '',
      uid: '',
      bio: '',
      culls: 0,
      friends: [],
      photoUrl: '',
      username: '');

  // void initState() {
  //   super.initState();
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(user!.uid)
  //       .get()
  //       .then((value) {
  //     loggedInUser = UserModel.fromSnap(value.data());
  //     setState(() {});
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(),
                ),
              );
            },
            icon: Icon(Icons.search),
          ),
        ],
        automaticallyImplyLeading: false,
        title: Text('Home'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(50, 5, 0, 0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Add a post',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add_photo_alternate_sharp),
                  onPressed: () {},
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPostScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

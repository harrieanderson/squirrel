import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:squirrel/models/usser_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({required Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  var loggedInUserFuture;

  @override
  void initState() {
    super.initState();
    final loggedInUserFuture =
        FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: loggedInUserFuture,
        builder: (context, snapshot) {
          final documentSnapshot = snapshot.data;
          UserModel? user;
          if (documentSnapshot != null) {
            user = UserModel.fromMap(snapshot.data!.data());
          }
          print('user: $user');

          return Center(
            child: Column(
              children: [
                Text(
                  'Home screen',
                  style: TextStyle(fontSize: 40),
                ),
                Text(
                  user?.firstName ?? '(user is null)',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

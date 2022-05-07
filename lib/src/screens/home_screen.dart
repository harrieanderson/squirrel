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
  UserModel loggedInUser = UserModel(
    email: '',
    firstName: '',
    secondName: '',
    uid: '',
  );

  @override
  void initState() {
    super.initState();
    //FirebaseFirestore.instance
    //    .collection('users')
    //    .doc(user!.uid)
    //    .get()
    //    .then((value) {
    //  loggedInUser = UserModel.fromMap(value.data());
    //  setState(() {});
    //});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
      ),
      //bottomNavigationBar: Container(),
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

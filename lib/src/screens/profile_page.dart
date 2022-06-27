// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:squirrel/helperfunctions/sharedpref_helper.dart';
import 'package:squirrel/models/usser_model.dart';
import 'package:squirrel/utils/utils.dart';

class ProfilePageUi extends StatefulWidget {
  final String uid;

  const ProfilePageUi({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfilePageUiState createState() => _ProfilePageUiState();
}

class _ProfilePageUiState extends State<ProfilePageUi> {
  Uint8List? _image;

  var userData = {};

  @override
  @override
  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void initState() {
    super.initState();
    getData();
  }

  // gets data from Firebase
  getData() async {
    try {
      var snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      userData = snap.data()!;
      setState(() {});
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Profile page'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red,
        elevation: 0,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            color: Colors.red,
            height: MediaQuery.of(context).size.height * 0.3,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(
                8.0,
              ),
              child: Column(
                children: <Widget>[
                  Stack(children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(userData['photoUrl']),
                      radius: 50,
                    ),
                    Positioned(
                      bottom: 1,
                      right: 1,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 15,
                        child: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            selectImage();
                          },
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    userData['username'],
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'North Yorkshire, England',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text('Add Friend'),
                      IconButton(onPressed: () {}, icon: Icon(Icons.person_add))
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text('Message'),
                      IconButton(onPressed: () {}, icon: Icon(Icons.mail))
                    ],
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Container(
              child: Column(
                children: <Widget>[
                  Text('User Information'),
                  Divider(),
                  ListTile(
                    title: Text('Location'),
                    subtitle: Text('North Yorkshire, England'),
                    leading: Icon(Icons.location_on),
                  ),
                  ListTile(
                    title: Text('culls'),
                    subtitle: Text('2'),
                    leading: Icon(Icons.gps_fixed_rounded),
                  ),
                  ListTile(
                    title: Text('Phone'),
                    subtitle: Text('123456789'),
                    leading: Icon(Icons.phone),
                  ),
                  ListTile(
                    title: Text('About me'),
                    subtitle: Text(userData['bio']),
                    leading: Icon(Icons.info),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

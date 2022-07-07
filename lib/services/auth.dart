import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:squirrel/models/usser_model.dart' as model;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:squirrel/helperfunctions/sharedpref_helper.dart';
import 'package:squirrel/services/database.dart';
import 'package:squirrel/services/storage_methods.dart';

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user details
  Future<model.UserModel> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.UserModel.fromSnap(documentSnapshot);
  }
}

class Authenticator {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signUpUser(
      {required String email,
      required String password,
      required String firstName,
      required String secondName,
      required String username,
      required String bio,
      required Uint8List? file}) async {
    String res = "An error occured";

    try {
      if (email.isNotEmpty ||
          firstName.isNotEmpty ||
          secondName.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty) {
        // register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String photoUrl =
            'https://firebasestorage.googleapis.com/v0/b/squirrel-84cdc.appspot.com/o/profilepics%2Fdefault_pic.png?alt=media&token=b1ab9a60-b5a8-4acd-aa32-a49167082fd6';
        if (file != null) {
          photoUrl = await StorageMethods()
              .uploadImageToStorage('profilepics', file, false);
        }

        //   model
        model.UserModel _user = model.UserModel(
            username: username,
            firstName: firstName,
            secondName: secondName,
            uid: cred.user!.uid,
            email: email,
            photoUrl: photoUrl,
            culls: 0,
            friends: [],
            bio: bio);

        // add user to our database
        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(_user.toMap());
        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  bool isUserLoggedIn() {
    return _auth.currentUser != null;
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    final FirebaseAuth _firebaseauth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    UserCredential result =
        await _firebaseauth.signInWithCredential(credential);
    final user = result.user;
    if (user != null) {
      await _saveUserData(user);
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    final credentials = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (credentials.user != null) {
      await _saveUserData(credentials.user!);
    }
  }

  signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await _auth.signOut();
  }

  Future<void> _saveUserData(User user) async {
    SharedPreferenceHelper().userEmail = user.email ?? '';
    SharedPreferenceHelper().userId = user.uid;
    var indexToDrop = user.email!.indexOf('@');
    if (indexToDrop < 0) {
      indexToDrop = user.email!.length;
    }
    SharedPreferenceHelper().userName = user.email!.substring(
      0,
      indexToDrop,
    );
    print('user name = ${SharedPreferenceHelper().userName}');
    SharedPreferenceHelper().displayName = user.displayName ?? "";
    SharedPreferenceHelper().userProfileUrl = user.photoURL ?? "";

    Map<String, dynamic> userInfoMap = {
      "email": SharedPreferenceHelper().userEmail,
      "username": SharedPreferenceHelper().userName,
      "name": SharedPreferenceHelper().displayName,
      "imgUrl": SharedPreferenceHelper().userProfileUrl,
    };

    await DatabaseMethods().addUserInfoToDB(user.uid, userInfoMap);
  }
}

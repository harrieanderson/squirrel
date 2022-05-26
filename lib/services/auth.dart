import 'dart:ffi';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:squirrel/helperfunctions/sharedpref_helper.dart';
import 'package:squirrel/services/database.dart';

class Authenticator {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> signUpUser(
      {required String email,
      required String password,
      required String username,
      required String bio,
      Uint8List? file}) async {
    String res = "An error occured";

    try {
      if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty) {
        // register user
        UserCredential cred = await auth.createUserWithEmailAndPassword(
            email: email, password: password);

        // add user to our database
        await firestore.collection('users').doc(cred.user!.uid).set({
          'username': username,
          'uid': cred.user?.uid,
          'email': email,
          'bio': bio,
          'friends': [],
          'culls': 0
        });
        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  User? getCurrentUser() {
    return auth.currentUser;
  }

  bool isUserLoggedIn() {
    return auth.currentUser != null;
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
    final credentials = await auth.signInWithEmailAndPassword(
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
    await auth.signOut();
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

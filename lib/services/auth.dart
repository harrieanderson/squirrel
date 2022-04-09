import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:squirrel/helperfunctions/sharedpref_helper.dart';
import 'package:squirrel/services/database.dart';

class Authenticator {
  final FirebaseAuth auth = FirebaseAuth.instance;

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
    SharedPreferenceHelper().displayName = user.displayName ?? '';
    SharedPreferenceHelper().userProfileUrl = user.photoURL ?? '';
    print('***** URL name = ${SharedPreferenceHelper().userProfileUrl}');

    Map<String, dynamic> userInfoMap = {
      "email": SharedPreferenceHelper().userEmail,
      "username": SharedPreferenceHelper().userName,
      "name": SharedPreferenceHelper().displayName,
      "imgUrl": SharedPreferenceHelper().userProfileUrl,
    };

    print(userInfoMap);

    await DatabaseMethods().addUserInfoToDB(user.uid, userInfoMap);
  }
}

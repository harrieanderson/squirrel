import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:squirrel/helperfunctions/sharedpref_helper.dart';
import 'package:squirrel/services/auth.dart';
import 'package:squirrel/src/app.dart';
import 'package:squirrel/src/screens/home_screen.dart';
import 'package:squirrel/src/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Future.wait([
    Firebase.initializeApp(),
    SharedPreferenceHelper.instance.initialise(),
  ]).then((_) => runApp(App()));
}

import 'package:flutter/material.dart';
import 'package:squirrel/services/auth.dart';
import 'package:squirrel/src/screens/home_screen.dart';
import 'package:squirrel/src/screens/login.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Authenticator().isUserLoggedIn()
          ? HomeScreen(key: UniqueKey())
          : LoginScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:squirrel/services/auth.dart';
import 'package:squirrel/src/screens/base_screen.dart';
import 'package:squirrel/src/screens/login.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Authenticator().getCurrentUser() != null
          ? BaseScreen(key: UniqueKey())
          : LoginScreen(),
    );
  }
}

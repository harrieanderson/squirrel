import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:squirrel/services/auth.dart';
import 'package:squirrel/src/app.dart';
import 'package:squirrel/src/screens/home_screen.dart';
import 'package:squirrel/src/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Email And password Login',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: FutureBuilder(
          future: AuthMethods().getCurrentUser(),
          builder: (context, AsyncSnapshot<User> snapshot) {
            if (snapshot.hasData) {
              return const HomeScreen();
            } else {
              return LoginScreen();
            }
          }),
    );
  }
}

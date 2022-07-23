import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:squirrel/models/user_provider.dart';
import 'package:squirrel/services/auth.dart';
import 'package:squirrel/src/screens/navigation_screen.dart';
import 'package:squirrel/src/screens/home_screen.dart';
import 'package:squirrel/src/screens/login.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Authenticator().getCurrentUser() != null
            ? NavigationScreen(
                key: UniqueKey(),
              )
            : LoginScreen(),
      ),
    );
  }
}

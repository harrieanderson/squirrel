import 'package:flutter/material.dart';
import 'package:squirrel/services/auth.dart';
import 'package:squirrel/src/screens/google_map_screen.dart';
import 'package:squirrel/src/screens/login.dart';
import 'package:squirrel/src/screens/messages/message.dart';
import 'package:squirrel/src/screens/profile_page.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            color: Colors.black,
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 30, bottom: 10),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(
                                'https://static-cdn.jtvnw.net/jtv_user_pictures/3340048d-4d54-4fb3-98ce-575758caf538-profile_image-300x300.jpg'))),
                  ),
                  Text(
                    'Harrie Anderson',
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                  Text(
                    'HarrieAnd@outlook.com',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(
              'Profile',
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ProfilePageUi()));
            },
          ),
          ListTile(
              leading: Icon(Icons.text_snippet_outlined),
              title: Text(
                'Messages',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MessagesScreen()));
              }),
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text(
              'Markings',
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GoogleMapScreen(key: UniqueKey())));
            },
          ),
          ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                'settings',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {}),
          Container(
            child: ListTile(
              leading: Icon(Icons.arrow_back),
              title: Text(
                'Logout',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                AuthMethods().signOut().then(({
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()))
                    }));
              },
            ),
          ),
        ],
      ),
    );
  }
}

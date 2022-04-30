import 'package:flutter/material.dart';
import 'package:squirrel/src/app.dart';

class ProfilePageUi extends StatefulWidget {
  @override
  _ProfilePageUiState createState() => _ProfilePageUiState();
}

class _ProfilePageUiState extends State<ProfilePageUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Profile page'),
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
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Stack(children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://scontent.flba3-1.fna.fbcdn.net/v/t39.30808-6/272059473_10224041200571270_2474966297877769639_n.jpg?_nc_cat=104&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=3UUeIYeWmlYAX-gmRhV&tn=IAl5phUutYdnzHba&_nc_ht=scontent.flba3-1.fna&oh=00_AT__xgdudmccvI83lDU9pNSxDXkqMUACHEuDfHv_Bny9Sw&oe=625EABA0'),
                      radius: 50,
                    ),
                    Positioned(
                        bottom: 3,
                        right: 2,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 15,
                          child: Icon(Icons.edit),
                        ))
                  ]),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Harrie Anderson',
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
                    title: Text('Total culls'),
                    subtitle: Text('15'),
                    leading: Icon(Icons.gps_fixed_rounded),
                  ),
                  ListTile(
                    title: Text('Phone'),
                    subtitle: Text('123456789'),
                    leading: Icon(Icons.phone),
                  ),
                  ListTile(
                    title: Text('About me'),
                    subtitle: Text('I am currently doing development'),
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

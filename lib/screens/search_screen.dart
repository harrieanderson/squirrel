import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:squirrel/helperfunctions/sharedpref_helper.dart';
import 'package:squirrel/models/repo.dart';
import 'package:squirrel/models/user.dart';
import 'package:squirrel/models/usser_model.dart';
import 'package:squirrel/services/database.dart';
import 'package:squirrel/src/screens/home_screen.dart';
import 'package:squirrel/src/screens/navigation_screen.dart';
import 'package:squirrel/src/screens/profile_page.dart';
import 'package:squirrel/src/widgets/PostContainer.dart';
import 'package:squirrel/utils/utils.dart';

class SearchScreen extends StatefulWidget {
  final String currentUserId;

  const SearchScreen({Key? key, required this.currentUserId}) : super(key: key);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchString = '';
  TextEditingController _searchController = TextEditingController();

  clearSearch() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _searchController.clear());
    setState(() {
      searchString = '';
    });
  }

  buildUserTile(UserModel user) {
    return ListTile(
      leading: CircleAvatar(
          radius: 20, backgroundImage: NetworkImage(userModel!.photoUrl)),
      title: Text(user.username),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProfilePageUi(
              uid: widget.currentUserId,
              visitedUserId: user.uid,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.5,
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 15),
            hintText: 'Search Users...',
            hintStyle: TextStyle(color: Colors.white),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.white),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.white,
              ),
              onPressed: () {
                clearSearch();
              },
            ),
            filled: true,
          ),
          onChanged: (input) {
            if (input.isNotEmpty) {
              setState(() {
                searchString = _searchController.text;
              });
            }
          },
        ),
      ),
      body: searchString.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Search Users...',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                  )
                ],
              ),
            )
          : FutureBuilder<List<UserModel>>(
              future: DatabaseMethods.searchUsers(searchString),
              builder: (context, snapshot) {
                final list = snapshot.data;
                if (list == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (list.isEmpty) {
                  return Center(
                    child: Text('No users found'),
                  );
                }
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return buildUserTile(list[index]);
                  },
                );
              },
            ),
    );
  }
}

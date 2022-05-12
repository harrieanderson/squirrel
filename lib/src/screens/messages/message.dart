import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:squirrel/helperfunctions/sharedpref_helper.dart';
import 'package:squirrel/services/auth.dart';
import 'package:squirrel/services/database.dart';
import 'package:squirrel/src/screens/login.dart';
import 'package:squirrel/src/screens/messages/chatscreen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  bool isSearching = false;
  late String myName, myProfilePic, myUserName, myEmail;
  late Stream usersStream, chatRoomsStream;

  TextEditingController searchUsernameEditingController =
      TextEditingController();

  getMyInfoFromSharedPreference() {
    myName = SharedPreferenceHelper().displayName;
    myProfilePic = SharedPreferenceHelper().userProfileUrl;
    myUserName = SharedPreferenceHelper().userName;
    myEmail = SharedPreferenceHelper().userEmail;
  }

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  onSearchBtnClick() async {
    isSearching = true;
    setState(() {});
    usersStream = await DatabaseMethods()
        .getUserByUsername(searchUsernameEditingController.text);
    setState(() {});
  }

  Widget chatRoomsList() {
    return StreamBuilder<dynamic>(
      stream: DatabaseMethods().getChatRooms(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs!.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data!.docs[index];
                  return ChatRoomListTile(ds['lastMessage'], ds.id, myUserName);
                })
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget searchListUserTile({required String profileUrl, name, email}) {
    return GestureDetector(
      onTap: () {
        var chatRoomId = getChatRoomIdByUsernames(myUserName, name);
        Map<String, dynamic> chatRoomInfoMap = {
          "users": [myUserName, name]
        };

        DatabaseMethods().createChatRoom(chatRoomId, chatRoomInfoMap);

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ChatsScreen(name, email)));
      },
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.network(
              profileUrl,
              height: 40,
              width: 40,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(name), Text(email)],
          )
        ],
      ),
    );
  }

  Widget searchUsersList() {
    return StreamBuilder<dynamic>(
      stream: usersStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data!.docs[index];
                  return searchListUserTile(
                      profileUrl: ds['imgUrl'],
                      name: ds['name'],
                      email: ds['email']);
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  getChatRooms() async {
    chatRoomsStream = await DatabaseMethods().getChatRooms();
  }

  onScreenLoaded() async {
    await getMyInfoFromSharedPreference();
    getChatRooms();
  }

  void initState() {
    onScreenLoaded();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Messages'),
        actions: [
          InkWell(
            onTap: () {
              Authenticator().signOut().then((s) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              });
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Row(
                children: [
                  isSearching
                      ? GestureDetector(
                          onTap: () {
                            isSearching = false;
                            searchUsernameEditingController.text = "";
                            setState(() {});
                          },
                          child: Padding(
                              padding: EdgeInsets.only(right: 12),
                              child: Icon(Icons.arrow_back)),
                        )
                      : Container(),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 16),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey,
                              width: 1,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(24)),
                      child: Row(
                        children: [
                          Expanded(
                              child: TextField(
                            controller: searchUsernameEditingController,
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: "username"),
                          )),
                          GestureDetector(
                              onTap: () {
                                if (searchUsernameEditingController.text !=
                                    "") {
                                  onSearchBtnClick();
                                }
                              },
                              child: Icon(Icons.search))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              isSearching ? searchUsersList() : chatRoomsList()
            ],
          )),
    );
  }
}

class ChatRoomListTile extends StatefulWidget {
  String lastMessage, chatRoomId, myUsername;
  ChatRoomListTile(this.lastMessage, this.chatRoomId, this.myUsername,
      {Key? key})
      : super(key: key);

  @override
  State<ChatRoomListTile> createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String profilePicUrl = "", name = "", username = "";

  getThisUserInfo() async {
    username =
        widget.chatRoomId.replaceAll(widget.myUsername, "").replaceAll("_", "");
    QuerySnapshot querySnapshot = await DatabaseMethods().getUserInfo(username);
    print(querySnapshot.size);
    name = "${querySnapshot.docs[0]['name']}";
    profilePicUrl = "${querySnapshot.docs[0]['imgUrl']}";
    setState(() {});
  }

  @override
  void initState() {
    getThisUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatsScreen(username, name)));
      },
      child: Row(
        children: [
          SizedBox(
            height: 40,
            width: 40,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Container(
              height: 40,
              width: 40,
              color: Colors.red,
            ),
            // child: Image.network(
            // profilePicUrl,
            // height: 30,
            // width: 30,
            // fit: BoxFit.cover,
          ),
          // ),
          SizedBox(
            width: 12,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 3,
              ),
              Text(widget.lastMessage)
            ],
          ),
        ],
      ),
    );
  }
}

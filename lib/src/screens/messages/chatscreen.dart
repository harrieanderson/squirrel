// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:squirrel/helperfunctions/sharedpref_helper.dart';
import 'package:squirrel/services/database.dart';
import 'package:random_string/random_string.dart';

class ChatsScreen extends StatefulWidget {
  final String chatWithUsername, name;
  ChatsScreen(this.chatWithUsername, this.name);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatsScreen> {
  late String chatRoomId, messageId = '';
  late String myName, myProfilePic, myUserName, myEmail;
  late Stream messageStream;
  TextEditingController messageTextEditingController = TextEditingController();

  getMyInfoFromSharedPreference() async {
    myName = (await SharedPreferenceHelper().getDisplayName())!;
    myProfilePic = (await SharedPreferenceHelper().getUserProfileUrl())!;
    myUserName = (await SharedPreferenceHelper().getUserName())!;
    myEmail = (await SharedPreferenceHelper().getUserEmail())!;

    chatRoomId = getChatRoomIdByUsernames(widget.chatWithUsername, myUserName);
  }

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  addMessage(bool sendClicked) {
    if (messageTextEditingController.text != "") {
      String message = messageTextEditingController.text;

      var lastMessageTs = DateTime.now();

      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendBy": myUserName,
        "ts": lastMessageTs,
        "imgUrl": myProfilePic
      };

      if (messageId == "") {
        messageId = randomAlphaNumeric(12);
      }

      DatabaseMethods()
          .addMessage(chatRoomId, messageId, messageInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageSendTs": lastMessageTs,
          "lastMessageSendBy": myUserName
        };

        DatabaseMethods().updateLastMessageSend(chatRoomId, lastMessageInfoMap);

        if (sendClicked) {
          // remove the text in the message input field
          messageTextEditingController.text = '';

          // make the message id blank to get regenerated on next message send
          messageId = '';
        }
      });
    }
  }

  Widget chatMessageTile(String message, bool sendByMe) {
    return Row(
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                bottomRight:
                    sendByMe ? Radius.circular(0) : Radius.circular(24),
                topRight: Radius.circular(24),
                bottomLeft: sendByMe ? Radius.circular(24) : Radius.circular(0),
              ),
              color: Colors.blue,
            ),
            padding: EdgeInsets.all(16),
            child: Text(
              message,
              style: TextStyle(color: Colors.white),
            )),
      ],
    );
  }

  // Widget chatMessages() {
  //   return StreamBuilder(
  //     stream: messageStream,
  //     builder: (context, snapshot) {
  //       return snapshot.hasData
  //           ? ListView.builder(
  //               itemCount: snapshot.data.docs.length,
  //               itemBuilder: (context, index) {
  //                 DocumentSnapshot ds = snapshot.data.docs[index];
  //                 return Text(ds["message"]);
  //               })
  //           : Center(child: CircularProgressIndicator());
  //     },
  //   );
  // }

  getAndSetMessages() async {
    messageStream = await DatabaseMethods().getChatRoomMessages(chatRoomId);
    setState(() {});
  }

  doThisOnLaunch() async {
    await getMyInfoFromSharedPreference();
    getAndSetMessages();
  }

  @override
  void initState() {
    doThisOnLaunch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.chatWithUsername),
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder<dynamic>(
                    stream: messageStream,
                    builder: (context, snapshot) {
                      return ListView.builder(
                        padding: EdgeInsets.only(bottom: 5, top: 16),
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot ds = snapshot.data.docs[index];
                          return chatMessageTile(
                              ds['message'], myUserName == ds['sendBy']);
                        },
                      );
                    }),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Row(
                  children: [
                    Icon(Icons.attach_file),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20 * 0.75),
                        decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(40)),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20 / 4,
                            ),
                            Expanded(
                                child: TextField(
                              controller: messageTextEditingController,
                              onChanged: (value) {
                                addMessage(false);
                              },
                              decoration: InputDecoration(
                                  hintText: 'Send a message',
                                  border: InputBorder.none),
                            )),
                            GestureDetector(
                              onTap: () {
                                addMessage(true);
                              },
                              child: Icon(
                                Icons.send,
                                color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.color
                                        ?.withOpacity(0.64) ??
                                    Colors.red,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

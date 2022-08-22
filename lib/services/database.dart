import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:squirrel/helperfunctions/sharedpref_helper.dart';
import 'package:squirrel/models/cull_model.dart';
import 'package:squirrel/models/post.dart';
import 'package:squirrel/models/sighting_model.dart';
import 'package:squirrel/models/usser_model.dart';
import 'package:squirrel/utils/constant.dart';

class DatabaseMethods {
  Future addUserInfoToDB(Map<String, dynamic> userInfoMap) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc('username')
        .set(userInfoMap);
  }

  static Future searchUsers(String name) async {
    // final doc = users.doc
    final users = await usersRef
        .where('name', isGreaterThanOrEqualTo: name)
        .where('name', isLessThan: name + 'z')
        .get();

    final listOfUserModels = <UserModel>[];
    for (var doc in docs) {
      listOfUserModels.add(
        UserModel.fromSnap(doc),
      );
    }
    return listOfUserModels;
  }

  Stream<QuerySnapshot> getUserByUsername(String username) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: username)
        .snapshots();
  }

  Future addMessage(String chatRoomId, String messageId,
      Map<String, dynamic> messageInfoMap) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(messageInfoMap);
  }

  updateLastMessageSend(
      String chatRoomId, Map<String, dynamic> lastMessageInfoMap) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }

  createChatRoom(
      String chatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();

    if (snapShot.exists) {
      // chatroom already exists
      return true;
    } else {
      // chatroom does not exist
      return FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatRoomMessages(chatRoomId) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('ts')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatRooms() {
    String? myUsername = SharedPreferenceHelper().userName;
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .orderBy("lastMessageSendTs", descending: true)
        .where("users", arrayContains: myUsername)
        .snapshots();
  }

  static void createPost(Post post) {
    postsRef.doc(post.authorId).set({'postTime': post.timestamp});
    postsRef.doc(post.authorId).collection("userPosts").add({
      // "username": post.username,
      "text": post.text,
      "image": post.image,
      "authorId": post.authorId,
      "timestamp": post.timestamp,
      "likes": post.likes
    });
  }

  static void addCull(Cull cull) {
    cullsRef.doc(cull.uid).set({'cullTime': cull.timestamp});
    cullsRef.doc(cull.uid).collection("userCulls").add({
      "uid": cull.uid,
      "gender": cull.gender,
      "timestamp": cull.timestamp,
      "location": cull.location
    });
  }

  static void addSighting(Sighting sighting) {
    sightingsRef.doc(sighting.uid).set({'sightingTime': sighting.timestamp});
    sightingsRef.doc(sighting.uid).collection("userSightings").add({
      "uid": sighting.uid,
      "species": sighting.colour,
      "timestamp": sighting.timestamp,
      "location": sighting.location
    });
  }

  static Future<List<Post>> getUserPosts(String userId) async {
    QuerySnapshot userPostsSnap = await postsRef
        .doc(userId)
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .get();
    List<Post> userPosts =
        userPostsSnap.docs.map((doc) => Post.fromDoc(doc)).toList();
    return userPosts;
  }

  static Future<List<Post>> getHomeScreenPosts(String userId) async {
    QuerySnapshot homePosts = await postsRef
        .doc(userId)
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .get();
    List<Post> posts = homePosts.docs.map((doc) => Post.fromDoc(doc)).toList();
    return posts;
  }

  Future<QuerySnapshot> getUserInfo(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("username", isGreaterThanOrEqualTo: username)
        .get();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String firstName;
  final String secondName;
  final String bio;
  final List friends;
  final int culls;

  const User({
    required this.username,
    required this.firstName,
    required this.secondName,
    required this.uid,
    required this.photoUrl,
    required this.email,
    required this.bio,
    required this.friends,
    required this.culls,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot["username"],
      uid: snapshot["uid"],
      firstName: snapshot['firstName'],
      secondName: snapshot['secondName'],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      bio: snapshot["bio"],
      friends: snapshot["friends"],
      culls: snapshot['culls'],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "firstname": firstName,
        "secondname": secondName,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "friends": friends,
        "culls": culls,
      };
}

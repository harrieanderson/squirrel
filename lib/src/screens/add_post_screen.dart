import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:squirrel/models/repo.dart';
import 'package:squirrel/models/user_provider.dart';
import 'package:squirrel/models/usser_model.dart';
import 'package:squirrel/services/firestore_methods.dart';
import 'package:squirrel/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:squirrel/models/repo.dart';

class AddPostScreen extends StatefulWidget {
  final String uid;
  const AddPostScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();

  void makePost(
    String uid,
    String username,
    String photoUrl,
  ) async {
    try {
      String res = await FirestoreMethods().uploadPost(
          _descriptionController.text, _file!, uid, username, photoUrl);

      if (res == "success") {
        // ignore: use_build_context_synchronously
        showSnackBar(context, 'Posted!');
      } else {
        showSnackBar(context, res);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void selectImage() async {
    Uint8List file = await pickImage(ImageSource.gallery);
    setState(() {
      _file = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserModel? userModel;

    // final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Make a post'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
          icon: Icon(Icons.close),
        ),
        actions: [
          IconButton(
              constraints: BoxConstraints.expand(width: 50),
              icon: Text(
                'Post',
                textAlign: TextAlign.center,
              ),
              onPressed: () => {}
              // makePost(
              // userModel!.uid, userModel.username, userModel.photoUrl),
              ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<UserModel>(
                future: Repo.getUser(widget.uid),
                builder: (context, snapshot) {
                  final userModel = snapshot.data;
                  if (userModel == null) {
                    return Container();
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            userModel.photoUrl,
                          ),
                        ),
                      ),
                      Text(
                        userModel.username,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                }),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: "What's happening?",
              suffixIcon: GestureDetector(
                onTap: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
                child: Icon(
                  Icons.image,
                ),
              ),
            ),
          ),
          // Container(
          //   decoration: BoxDecoration(
          //     image: DecorationImage(
          //       image: MemoryImage(_file!),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}

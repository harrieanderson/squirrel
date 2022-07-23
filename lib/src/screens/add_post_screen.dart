import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:squirrel/models/repo.dart';
import 'package:squirrel/models/user_provider.dart';
import 'package:squirrel/models/usser_model.dart';
import 'package:squirrel/services/firestore_methods.dart';
import 'package:squirrel/utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  final String uid;
  const AddPostScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool _isLoading = false;

  final TextEditingController _postText = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _postText.dispose();
  }

  void selectImage() async {
    Uint8List file = await pickImage(ImageSource.gallery);
    setState(() {
      _file = file;
    });
  }

  void makePost(String uid, String username, String profImage) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
        _postText.text,
        _file!,
        uid,
        username,
        profImage,
      );
      if (res == 'success') {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(
          context,
          'posted!',
        );
        clearImage();
      } else {
        showSnackBar(context, res);
      }
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  void clearImage() {
    setState(() {
      _file == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Make a post'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close),
        ),
        actions: [
          IconButton(
            constraints: BoxConstraints.expand(
              width: 50,
            ),
            icon: Text(
              'Post',
              textAlign: TextAlign.center,
            ),
            onPressed: () => makePost(
              userProvider.getUser.uid,
              userProvider.getUser.username,
              userProvider.getUser.photoUrl,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(
              8.0,
            ),
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
              },
            ),
          ),
          TextField(
            decoration: InputDecoration(
              labelText: "What's happening?",
              suffixIcon: GestureDetector(
                onTap: () => selectImage(),
                child: Icon(
                  Icons.image,
                ),
              ),
            ),
            onChanged: (value) {
              _postText.text = value;
            },
          ),
          SizedBox(
            height: 3,
          ),
          _file == null
              ? Container()
              : Column(
                  children: [
                    Container(
                      height: 200,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Image.memory(_file!),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

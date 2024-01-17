import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone_project/models/user.dart';
import 'package:instagram_clone_project/providers/user_provider.dart';
import 'package:instagram_clone_project/resources/firestore_methods.dart';
import 'package:instagram_clone_project/utils/colors.dart';
import 'package:instagram_clone_project/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});
  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  TextEditingController _captionController = TextEditingController();
  Uint8List? _file;
  bool _isLoading = false;
  _postImage(
    String uid,
    String username,
    String profileImage
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
        _captionController.text,
        _file!, uid,
        username,
        profileImage
      );
      setState(() {
        _isLoading = false;
      });
      if(res == 'Success'){
        showSnackBar(context, 'Posted');
      }
      else
        showSnackBar(context, res);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    clearImage();

  }
  
  @override
  void dispose(){
    super.dispose();
    _captionController.dispose();
  }

  void clearImage(){
    setState(() {
      _file = null;
    });
  }

  _selectImage(BuildContext context) async {
    return showDialog(context : context, builder : (context){
      return SimpleDialog(
        title: const Text('Create a Post'),
        children: [
          SimpleDialogOption(
            padding: EdgeInsets.all(20),
            child: const Text('Take a photo'),
            onPressed: ()async{
              Navigator.of(context).pop();
              Uint8List file = await pickImage(ImageSource.camera);
              setState(() {
                _file = file;
              });
            },
          ),
          SimpleDialogOption(
            padding: EdgeInsets.all(20),
            child: const Text('Choose from gallery'),
            onPressed: ()async {
              Navigator.of(context).pop();
              Uint8List file = await pickImage(ImageSource.gallery);
              setState(() {
                _file = file;
              });
            },
          ),
          SimpleDialogOption(
            padding: EdgeInsets.all(20),
            child: const Text('Cancel'),
            onPressed: ()async {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return
    _file==null?
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: ()=>_selectImage(context),
            icon: const Icon(
              Icons.upload,
            )
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Create a new post',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ]
      ),
    ):
    Scaffold(
      appBar: AppBar(
        backgroundColor:mobileBackgroundColor,
        leading: IconButton(
          onPressed: clearImage,
          icon: Icon(Icons.close_sharp)
        ),
        title: const Text('New Post'),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () => _postImage(user.uid,user.username,user.photoUrl), 
            child: const Text(
              'Post',
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children : [
          const Divider(),
          _isLoading?
          const Column(      
            children: [
              LinearProgressIndicator(),
              SizedBox(
                height : 10,
              )
            ],
          ):
          const SizedBox(
            height : 20,
          ),
          
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: Image(
                  image: MemoryImage(_file!),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: TextField(
                  controller : _captionController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(5),
                    hintText: 'Write a caption...',
                    border: InputBorder.none,
                  ),
                  maxLines: 5,
                ),
              ),
            ],
          ),
        ]
      ),
    );
  }
}
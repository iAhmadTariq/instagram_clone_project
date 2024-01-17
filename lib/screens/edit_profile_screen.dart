import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone_project/resources/firestore_methods.dart';
import 'package:instagram_clone_project/resources/storage_methods.dart';
import 'package:instagram_clone_project/utils/colors.dart';
import 'package:instagram_clone_project/utils/utils.dart';
import 'package:instagram_clone_project/widgets/text_field_input.dart';

class EditProfileScreen extends StatefulWidget {
  var userData = {};
  String uid;
  EditProfileScreen({super.key, required this.userData, required this.uid});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  Uint8List? _image;
  bool isLoading = false;
  bool isPicChanged = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _usernameController.text = widget.userData['username'];
    _bioController.text = widget.userData['bio'];
  }

  void selectImage() async {
    isPicChanged = true;
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void updateProfile() async {
    setState(() {
      isLoading = true;
    });
    String photoUrl;
    isPicChanged?
    photoUrl = await StorageMethods().uploadImageToStorage('profilePic', _image!, false):
    photoUrl = widget.userData['photoUrl']; 
    String res = await FirestoreMethods().updateData(
      uid: widget.uid,
      username: _usernameController.text,
      bio: _bioController.text,
      photoUrl: photoUrl
    );
    setState(() {
      isLoading = false;
    });
    if (res != 'success') {
      showSnackBar(context, res);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title:Text(
            'Edit Profile',
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close),
          ),
          actions: [
            isLoading?
            Center(child: CircularProgressIndicator()):
            IconButton(
              onPressed: updateProfile,
              icon: Icon(
                Icons.check,
                color: Colors.blue,
              ),
            )
            
          ],
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(flex: 1, child: Container()),
                _image == null
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            NetworkImage(widget.userData['photoUrl']),
                        backgroundColor: Colors.grey,
                      )
                    : CircleAvatar(
                        radius: 50,
                        backgroundImage: MemoryImage(_image!),
                        backgroundColor: Colors.grey,
                      ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: selectImage,
                  child: Text(
                    'Change profile pic',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Change username',
                    border: UnderlineInputBorder(),
                    filled: false,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _bioController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Change bio',
                    border: UnderlineInputBorder(),
                    filled: false,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Flexible(
                  flex: 3,
                  child: Container(),
                )
              ],
            ),
          ),
        ));
  }
}

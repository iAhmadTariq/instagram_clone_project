import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone_project/resources/auth_methods.dart';
import 'package:instagram_clone_project/screens/login_screen.dart';
import 'package:instagram_clone_project/utils/colors.dart';
import 'package:instagram_clone_project/utils/utils.dart';
import 'package:instagram_clone_project/widgets/text_field_input.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;
  bool _hidePass = true;

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUp() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _image!);
    setState(() {
      _isLoading = false;
    });

    if (res != 'Success') {
      showSnackBar(context, res);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: ((context) => const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout()))));
    }
  }

  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _bioController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context)
    );
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(
                                'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
                          ),
                    Positioned(
                      bottom: -10,
                      left: 60,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: Icon(Icons.add_a_photo),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                TextFildInput(
                  hintText: 'Username here',
                  textEditingController: _usernameController,
                  textInputType: TextInputType.name,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFildInput(
                  hintText: 'Email here',
                  textEditingController: _emailController,
                  textInputType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _hidePass = !_hidePass;
                      });
                    },
                    icon: _hidePass
                        ?const  Icon(Icons.visibility,color: Colors.grey,)
                        : const Icon(Icons.visibility_off, color: Colors.grey,),
                  ),
                  hintText: "Password here",
                  border: inputBorder,
                  focusedBorder: inputBorder,
                  enabledBorder: inputBorder,
                  filled: true,
                  contentPadding: EdgeInsets.all(8),
                ),
                keyboardType: TextInputType.visiblePassword,
                obscureText: _hidePass,
              ),
                SizedBox(
                  height: 10,
                ),
                TextFildInput(
                  hintText: 'Your bio here',
                  textEditingController: _bioController,
                  textInputType: TextInputType.name,
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  //for sugnUP button
                  onTap: signUp,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      color: blueColor,
                    ),
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          )
                        : const Text('Sign up'),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //For Login Button if account already have
                    Container(
                      child: Text("Already have an account? "),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => LoginScreen()),
                          ),
                        );
                      },
                      child: Container(
                        child: Text(
                          "Log in",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ],
                ),
                
              ],
            ),
          ),
        ),
      
    );
  }
}

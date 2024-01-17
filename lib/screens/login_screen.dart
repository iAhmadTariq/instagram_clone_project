import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone_project/resources/auth_methods.dart';
import 'package:instagram_clone_project/screens/signup_screen.dart';
import 'package:instagram_clone_project/utils/colors.dart';
import 'package:instagram_clone_project/utils/utils.dart';
import 'package:instagram_clone_project/widgets/text_field_input.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _hidePass = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().logInUser(
        email: _emailController.text, password: _passwordController.text);
    setState(() {
      _isLoading = false;
    });
    if (res != 'Success') {
      showSnackBar(context, res);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: ((context) => const ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(),
              ))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(flex: 2, child: Container()),
              SvgPicture.asset(
                'assets/ic_instagram.svg',
                color: primaryColor,
                height: 64,
              ),
              SizedBox(
                height: 50,
              ),
              TextFildInput(
                  hintText: 'Email here',
                  textEditingController: _emailController,
                  textInputType: TextInputType.emailAddress),
              SizedBox(
                height: 20,
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
                height: 20,
              ),
              InkWell(
                onTap: loginUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    color: blueColor,
                  ),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : const Text('Log in'),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Flexible(flex: 2, child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text("Don't have an account? "),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => SignUpScreen())));
                    },
                    child: Container(
                      child: Text(
                        "Sign up",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

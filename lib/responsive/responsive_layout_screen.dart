import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:instagram_clone_project/providers/user_provider.dart';
import 'package:instagram_clone_project/utils/global_variables.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget mobileScreenLayout;
  final Widget webScreenLayout;
  const ResponsiveLayout({
    Key? key, 
    required this.mobileScreenLayout,
    required this.webScreenLayout
  }): super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
  }
  addData() async{
    UserProvider _userProvider = Provider.of(context,listen: false);
    await _userProvider.refreshUser();
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraints){
        if(constraints.maxWidth > webScreenSize){
          return widget.webScreenLayout;
        }
        else{
          return widget.mobileScreenLayout;
        }
          
      }),
    );
  }
}
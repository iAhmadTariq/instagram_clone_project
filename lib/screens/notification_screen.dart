import 'package:flutter/material.dart';
import 'package:instagram_clone_project/utils/colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text('Notifications'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
          child: Text(
            'Sorry for inconvenience, our team is working on it',
          )
        ),
    );
  }
}

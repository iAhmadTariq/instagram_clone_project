import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_project/models/user.dart';
import 'package:instagram_clone_project/screens/profile_screen.dart';
import 'package:instagram_clone_project/utils/colors.dart';
import 'package:instagram_clone_project/utils/utils.dart';

class ShowPeopleScreen extends StatefulWidget {
  String listType;
  String uid;
  String title;
  ShowPeopleScreen(
      {super.key,
      required this.listType,
      required this.uid,
      required this.title});

  @override
  State<ShowPeopleScreen> createState() => _ShowPeopleScreenState();
}

class _ShowPeopleScreenState extends State<ShowPeopleScreen> {
  List<dynamic> peopleList = [];
  List<DocumentSnapshot> userSnapshots = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void getData() async {}

  Future<List<DocumentSnapshot>> fetchUserData() async {
    var userSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get();
    peopleList = userSnap.data()![widget.listType];
    for (String uid in peopleList) {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        userSnapshots.add(userDoc);
      }
    }

    return userSnapshots;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: mobileBackgroundColor,
        ),
        body: FutureBuilder<List<DocumentSnapshot>>(
          future: fetchUserData(), // Replace with your data retrieval function
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              // If there's an error, d\\isplay an error message
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              // If there's no data or an empty list, display a message
              return Container(
                padding: EdgeInsets.all(20),
                child: Text('No ${widget.listType}'),
              );
            } else {
              // If data is available, build the ListView with ListTile widgets
              final userDocs = snapshot.data!;
              return ListView.builder(
                itemCount: userDocs.length,
                itemBuilder: (BuildContext context, int index) {
                  final userData =
                      userDocs[index].data() as Map<String, dynamic>;

                  return InkWell(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ProfileScreen(uid: userData['uid']))),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          userData['photoUrl'],
                        ),
                      ),
                      title: Text(
                        userData['username'],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ));
  }
}

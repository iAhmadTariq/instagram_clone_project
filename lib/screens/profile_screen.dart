import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_project/resources/firestore_methods.dart';
import 'package:instagram_clone_project/screens/edit_profile_screen.dart';
import 'package:instagram_clone_project/screens/login_screen.dart';
import 'package:instagram_clone_project/screens/show_people_screen.dart';
import 'package:instagram_clone_project/utils/colors.dart';
import 'package:instagram_clone_project/utils/utils.dart';
import 'package:instagram_clone_project/widgets/follow_button.dart';
import 'package:share_plus/share_plus.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postlen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
 
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  void getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      postlen = postSnap.docs.length;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      userData = userSnap.data()!;
      setState(() {});
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  void shareButton() {
    String message =
        'Check out my flutter App,\nhttps://drive.google.com/drive/folders/1Pm1XEwal2Vq587zsjPATbGTFlaU9XgKK?usp=sharing';
    Share.share(message);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: mobileBackgroundColor,
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(
                userData['username'],
              ),
              actions: [
                FirebaseAuth.instance.currentUser!.uid == widget.uid
                    ? IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                              ),
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return Container(
                                  padding: EdgeInsets.only(right: 15, left: 15),
                                  height: 90,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 35,
                                        child: Center(
                                          child: IconButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            icon: Icon(
                                                Icons.arrow_drop_down_sharp),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      InkWell(
                                        onTap: signOut,
                                        child: Container(
                                          height: 35,
                                          width: double.infinity,
                                          child: const Row(
                                            children: [
                                              Icon(
                                                Icons.logout_sharp,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 8),
                                                child: Text(
                                                  'Sign Out',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                        icon: Icon(Icons.menu),
                      )
                    : Container()
              ],
            ),
            body: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(userData['photoUrl']),
                                radius: 45,
                              ),
                              Expanded(
                                  child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  buildColumn(postlen, 'Posts'),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ShowPeopleScreen(
                                            listType: 'followers',
                                            uid: widget.uid,
                                            title: "Followers",
                                          ),
                                        ),
                                      );
                                    },
                                    child: buildColumn(followers, 'Followers'),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ShowPeopleScreen(
                                            listType: 'following',
                                            uid: widget.uid,
                                            title: "Following",
                                          ),
                                        ),
                                      );
                                    },
                                    child: buildColumn(following, 'Following'),
                                  ),
                                ],
                              )),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            userData['username'],
                            style: TextStyle(fontSize: 15),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            userData['bio'],
                            style: TextStyle(fontSize: 15),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FirebaseAuth.instance.currentUser!.uid ==
                                      widget.uid
                                  ? Expanded(
                                    child: FollowButton(
                                        backgroundColor:
                                            secondMobileBackgroundColor,
                                        text: "Edit Profile",
                                        textColor: primaryColor,
                                        onFunction: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditProfileScreen(
                                                userData: userData,
                                                uid: FirebaseAuth
                                                    .instance.currentUser!.uid,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                  )
                                  : isFollowing
                                      ? Expanded(
                                        child: FollowButton(
                                            backgroundColor:
                                                secondMobileBackgroundColor,
                                            text: 'Unfollow',
                                            textColor: Colors.white,
                                            onFunction: () async {
                                              await FirestoreMethods().followUser(
                                                  uid: FirebaseAuth
                                                      .instance.currentUser!.uid,
                                                  followId: userData['uid']);
                                              setState(() {
                                                isFollowing = false;
                                                followers--;
                                              });
                                            },
                                          ),
                                      )
                                      : Expanded(
                                        child: FollowButton(
                                            backgroundColor: Colors.blue,
                                            text: 'Follow',
                                            textColor: Colors.white,
                                            onFunction: () async {
                                              await FirestoreMethods().followUser(
                                                  uid: FirebaseAuth
                                                      .instance.currentUser!.uid,
                                                  followId: userData['uid']);
                                              setState(() {
                                                isFollowing = true;
                                                followers++;
                                              });
                                            },
                                          ),
                                      ),
                              Expanded(
                                child: FollowButton(
                                  backgroundColor: secondMobileBackgroundColor,
                                  text: "Share Profile",
                                  textColor: Colors.white,
                                  onFunction: shareButton,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('posts')
                            .where('uid', isEqualTo: widget.uid)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return GridView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  (snapshot.data! as dynamic).docs.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3, childAspectRatio: 1),
                              itemBuilder: (context, index) {
                                DocumentSnapshot snap =
                                    (snapshot.data! as dynamic).docs[index];

                                return Container(
                                  child: Image.network(snap['postUrl'],
                                      fit: BoxFit.cover),
                                );
                              });
                        })
                  ],
                ),
              ],
            ),
          );
  }

  Column buildColumn(int value, String state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 5),
          child: Text(
            state,
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

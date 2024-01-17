import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_project/models/user.dart';
import 'package:instagram_clone_project/providers/user_provider.dart';
import 'package:instagram_clone_project/resources/firestore_methods.dart';
import 'package:instagram_clone_project/screens/profile_screen.dart';
import 'package:instagram_clone_project/utils/colors.dart';
import 'package:instagram_clone_project/widgets/comment_card.dart';
import 'package:instagram_clone_project/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Postcard extends StatefulWidget {
  final snap;

  Postcard({super.key, required this.snap});

  @override
  State<Postcard> createState() => _PostcardState();
}

class _PostcardState extends State<Postcard> {
  bool isLikeAnimating = false;
  TextEditingController _commentController = TextEditingController();
  int commentLength = 0;
  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLength = snap.docs.length;
    } catch (e) {
      print(e.toString());
    }
    setState(() {});
  }

  openProfile() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ProfileScreen(uid: widget.snap['uid'])));
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: mobileBackgroundColor,
      padding: EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 6,
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: openProfile,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(
                      widget.snap['profileImg'],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: openProfile,
                          child: Text(
                            widget.snap['username'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods().likePost(
                  widget.snap['postId'], user.uid, widget.snap['likes']);
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(
                      milliseconds: 400,
                    ),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 100,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  icon: widget.snap['likes'].contains(user.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_border,
                        ),
                  onPressed: () => FirestoreMethods().likePost(
                    widget.snap['postId'].toString(),
                    user.uid,
                    widget.snap['likes'],
                  ),
                ),
              ),
              IconButton(
                  onPressed: () async {
                    /*Following code is actually another screen but for some reasons
                  I could not make other screen So code will lay here
                  .
                ******************************************************************************************************************/
                    await showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(12))),
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return SafeArea(
                            top: true,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.95,
                              child: Column(
                                children: [
                                  Container(
                                      height: kToolbarHeight,
                                      width: double.infinity,
                                      child: const Center(
                                        child: Text(
                                          'Comments',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      )),
                                  Expanded(
                                    child: Container(
                                      child: StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('posts')
                                              .doc(widget.snap['postId'])
                                              .collection('comments')
                                              .orderBy('datePublished',
                                                  descending: true)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            String postId =
                                                widget.snap['postId'];
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }
                                            return ListView.builder(
                                              itemCount:
                                                  (snapshot.data! as dynamic)
                                                      .docs
                                                      .length,
                                              itemBuilder: (context, index) =>
                                                  CommentCard(
                                                      snap: (snapshot.data!
                                                              as dynamic)
                                                          .docs[index]
                                                          .data(),
                                                      postId: postId),
                                            );
                                          }),
                                    ),
                                  ),
                                  Divider(),
                                  SafeArea(
                                      child: Container(
                                    height: kToolbarHeight,
                                    margin: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom,
                                    ),
                                    padding:
                                        EdgeInsets.only(left: 16, right: 8),
                                    child: Row(children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          user.photoUrl,
                                        ),
                                        radius: 16,
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 12),
                                          child: TextField(
                                              controller: _commentController,
                                              maxLines: 1,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: 'Add a comment',
                                              )),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          await FirestoreMethods().postComment(
                                              widget.snap['postId'],
                                              _commentController.text,
                                              user.uid,
                                              user.username,
                                              user.photoUrl);
                                          setState(() {
                                            _commentController.text = "";
                                          });
                                        },
                                        child: Container(
                                          child: Text(
                                            'Post',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: blueColor,
                                            ),
                                          ),
                                        ),
                                      )
                                    ]),
                                  )),
                                ],
                              ),
                            ),
                          );
                        });
                    //Here This other screen code ends
                    //******************************************************************************************************************************
                  },
                  icon: Icon(
                    Icons.comment,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.send,
                  )),
              Expanded(
                child: Container(),
              ),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.bookmark_border_rounded,
                  )),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontWeight: FontWeight.w800),
                    child: Text(
                      '${widget.snap['likes'].length} likes',
                      style: Theme.of(context).textTheme.bodyMedium,
                    )),
                Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 8),
                    child: RichText(
                      text: TextSpan(
                          style: TextStyle(
                            color: primaryColor,
                          ),
                          children: [
                            TextSpan(
                              text: widget.snap['username'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: ' ${widget.snap['caption']}')
                          ]),
                    )),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 4,
                  ),
                  child: InkWell(
                    onTap: () async {
                      /*Following code is actually another screen but for some reasons
                  I could not make other screen So code will lay here
                  .
                ******************************************************************************************************************/
                    await showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(12))),
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return SafeArea(
                            top: true,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.95,
                              child: Column(
                                children: [
                                  Container(
                                      height: kToolbarHeight,
                                      width: double.infinity,
                                      child: Center(
                                        child: Text(
                                          'Comments',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      )),
                                  Expanded(
                                    child: Container(
                                      child: StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('posts')
                                              .doc(widget.snap['postId'])
                                              .collection('comments')
                                              .orderBy('datePublished',
                                                  descending: true)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            String postId =
                                                widget.snap['postId'];
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }
                                            return ListView.builder(
                                              itemCount:
                                                  (snapshot.data! as dynamic)
                                                      .docs
                                                      .length,
                                              itemBuilder: (context, index) =>
                                                  CommentCard(
                                                      snap: (snapshot.data!
                                                              as dynamic)
                                                          .docs[index]
                                                          .data(),
                                                      postId: postId),
                                            );
                                          }),
                                    ),
                                  ),
                                  Divider(),
                                  SafeArea(
                                      child: Container(
                                    height: kToolbarHeight,
                                    margin: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom,
                                    ),
                                    padding:
                                        EdgeInsets.only(left: 16, right: 8),
                                    child: Row(children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          user.photoUrl,
                                        ),
                                        radius: 16,
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 12),
                                          child: TextField(
                                              controller: _commentController,
                                              maxLines: 1,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: 'Add a comment',
                                              )),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          await FirestoreMethods().postComment(
                                              widget.snap['postId'],
                                              _commentController.text,
                                              user.uid,
                                              user.username,
                                              user.photoUrl);
                                          setState(() {
                                            _commentController.text = "";
                                          });
                                        },
                                        child: Container(
                                          child: Text(
                                            'Post',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: blueColor,
                                            ),
                                          ),
                                        ),
                                      )
                                    ]),
                                  )),
                                ],
                              ),
                            ),
                          );
                        });
                    //Here This other screen code ends
                    //******************************************************************************************************************************
                  
                    },
                    child: Text(
                      'view all $commentLength comments',
                      style: TextStyle(fontSize: 16, color: secondaryColor),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 4,
                  ),
                  child: Text(
                    DateFormat.yMMMd()
                        .format(widget.snap['datePublished'].toDate()),
                    style: TextStyle(
                      fontSize: 12,
                      color: secondaryColor,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}



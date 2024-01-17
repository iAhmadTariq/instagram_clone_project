import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Post{
  final String caption;
  final String uid;
  final String username;
  final String postId;
  final String postUrl;
  final datePublished;
  final String profileImg;
  final likes;
  
  const Post({
    required this.caption,
    required this.username,
    required this.uid,
    required this.datePublished,
    required this.postId,
    required this.postUrl,
    required this.profileImg,
    required this.likes,
  });
  Map<String,dynamic> toJason() => {
    'username' : username,
    'uid' : uid,
    'caption' : caption,
    'postId' : postId,
    'postUrl' : postUrl,
    'datePublished' : datePublished,
    'profileImg' : profileImg,
    'likes' : likes,
  };

  static Post fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String,dynamic>;
    return Post(
      username: snapshot['username'], 
      uid: snapshot['uid'], 
      caption: snapshot['caption'], 
      postId: snapshot['postId'], 
      postUrl: snapshot['postUrl'], 
      datePublished: snapshot['datePublished'], 
      profileImg: snapshot['profileImg'],
      likes: snapshot['likes']
    );
  }
}
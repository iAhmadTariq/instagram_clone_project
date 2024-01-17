import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_project/screens/add_post_screen.dart';
import 'package:instagram_clone_project/screens/feed_screen.dart';
import 'package:instagram_clone_project/screens/notification_screen.dart';
import 'package:instagram_clone_project/screens/profile_screen.dart';
import 'package:instagram_clone_project/screens/search_screen.dart';

const webScreenSize = 600;

var homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  NotificationScreen(),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid,),
];  
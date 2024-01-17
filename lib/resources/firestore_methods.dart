import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone_project/models/post.dart';
import 'package:instagram_clone_project/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<String> uploadPost(
    String caption,
    Uint8List file,
    String uid,
    String username,
    String profileImage
  ) async{
    
    String res = 'Some error occured';
    try {
      String postUrl = await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1();

      Post post = Post(
        caption: caption, 
        username: username, 
        uid: uid, 
        datePublished: DateTime.now(), 
        postId: postId, 
        postUrl: postUrl, 
        profileImg: profileImage, 
        likes: []
      );

      _firestore.collection('posts').doc(postId).set(post.toJason());
      res = 'Success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
  
  Future<void> postComment(String postId,String text,String uid, String name, String profileImg)async{
    try{
      if(text.isNotEmpty){
        String commentId = const Uuid().v1();
        _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set({
          'profileImg' : profileImg,
          'name' : name,
          'text' :text,
          'uid' :uid,
          'commentId' : commentId,
          'datePublished' : DateTime.now()
        });
      }else{
        print('text is empty');
      }
    }catch(e){
      print(e.toString());
    }
  }

  Future<void> deleteComment(String postId, String commentId)async{
    try {
      await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).delete();
      print(postId);
      print(commentId);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followUser({
    required String uid,
    required String followId
    }) async{
      try {
        DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
        List following = (snap.data()! as dynamic)['following'];
        if(following.contains(followId)){
          await _firestore.collection('users').doc(uid).update({
            'following' : FieldValue.arrayRemove([followId])
          });
          await _firestore.collection('users').doc(followId).update({
            'followers' : FieldValue.arrayRemove([uid])
          });
        }
        else{
          await _firestore.collection('users').doc(uid).update({
            'following' : FieldValue.arrayUnion([followId])
          });
          await _firestore.collection('users').doc(followId).update({
            'followers' : FieldValue.arrayUnion([uid])
          });
        }
      } catch (e) {
        print(e.toString()); 
      } 
    }
    Future<String> updateData({required String uid,required String username,required String bio,required String photoUrl} )async{
      try {

        await _firestore.collection('users').doc(uid).update({
          'username' : username,
          'bio' : bio,
          'photoUrl' : photoUrl
        });
        QuerySnapshot querySnapshot = await _firestore.collection('posts').where('uid',isEqualTo: uid).get();
        for(QueryDocumentSnapshot documentSnapshot in querySnapshot.docs){
          String documentId = documentSnapshot.id;
          await _firestore.collection('posts').doc(documentId).update({
            'username' : username,
            'profileImg' : photoUrl
          });
        }
        return 'success';
      } catch (e) {
        return e.toString();
      }
    }
}
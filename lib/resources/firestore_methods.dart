import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:instaclone/models/post.dart';
import 'package:instaclone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload image
  Future<String> uploadPost({
    required String description,
    required Uint8List file,
    required String uid,
    required String username,
    required String profImage,
  }) async {
    String res = "Some error occured";
    try {
      String photoUrl =
          await StorageMethod().uploadImagetoStorage("posts", file, true);
      print("Uploaded");
      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );
      print("Trying to post");
      _firestore.collection("posts").doc(postId).set(post.toJson());
      print(" Posted");
      res = "Success";
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  Future<void> likePost(
    String postId,
    String uid,
    List likes,
  ) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection("posts").doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection("posts").doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> postComments(
    String postId,
    String text,
    String uid,
    String name,
    String profilePic,
  ) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .set({
          "profilePic": profilePic,
          'name': name,
          "uid": uid,
          "text": text,
          "commentId": commentId,
          'datePublished': DateTime.now(),
        });
      }else{
        print('text is empty');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //Deleting the Post
  Future<void> deletePost(String postId) async{
    try{
      await _firestore.collection("posts").doc(postId).delete();
    }catch(error){
      print(error.toString());
    }
  }
}

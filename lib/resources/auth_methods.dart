import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error Occured";
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty) {
        //register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        //storing the image
        String photoUrl = await StorageMethod().uploadImagetoStorage(
          'profilePics',
          file,
          false,
        );
        print(photoUrl);

        //add user to our database
        await _firestore.collection("users").doc(cred.user!.uid).set({
          'username': username,
          'uid': cred.user!.uid,
          'email': email,
          'bio': bio,
          'followers': [],
          'following': [],
          'photoUrl': photoUrl,
        });

        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //logging in the user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "success";
      } else {
        res = "user need's to enter all the fields";
      }
    } 
    catch (err) {
      
      res = err.toString();
      print(res);
    }
    return res;
  }
}

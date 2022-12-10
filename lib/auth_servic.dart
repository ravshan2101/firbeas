import 'dart:ffi';

import 'package:firbeas/prefs_servic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Authservic {
  static final _auth = FirebaseAuth.instance;

  static Future<User?> signInUser(
      BuildContext context, String email, String password) async {
    try {
      _auth.signInWithEmailAndPassword(email: email, password: password);
      final User user = await _auth.currentUser!;
      print(user.toString());
      return user;
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<User?> signUpUser(BuildContext context, String fullname,
      String email, String password) async {
    try {
      var authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = authResult.user;
      return user;
    } catch (e) {
      print(e);
    }
    return null;
  }

  static void signOutUser(BuildContext context) {
    _auth.signOut();
    Prefs.removeUserId()
        .then((value) => {Navigator.pushReplacementNamed(context, 'sign_in')});
  }
}

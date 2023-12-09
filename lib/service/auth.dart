import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  static AuthService shared = AuthService();

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(
      String email, String password,BuildContext context) async {
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password,BuildContext context) async {
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
      return null;
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}

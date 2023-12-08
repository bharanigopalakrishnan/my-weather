import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myweather/controllers/userController.dart';
import 'package:myweather/model/config.dart';
import 'package:myweather/service/auth.dart';
import 'package:myweather/model/user.dart' as us;
import 'package:provider/provider.dart';

class LoginPageViewModel {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  StreamController streamController = StreamController.broadcast();
  bool loader = true;

  Future<us.User?> login() async {
    us.User? userData;
    User? user = await AuthService.shared.signInWithEmailAndPassword(
        emailController.text, passwordController.text);
    if (user != null && user.email != null) {
      userData = us.User(email: user.email);
    }
    return userData;
  }

  signUp() async {
    User? user = await AuthService.shared.signUpWithEmailAndPassword(
        emailController.text, passwordController.text);
    if (user != null && user.email != null) {
    } else {}
  }

  validateUser(BuildContext context) async {
    us.User? userData =
        await Provider.of<UserController>(context, listen: false)
            .loadCountFromLocalStorage();

    if (userData?.email != null) {
      loadConfigJson();
      Navigator.popAndPushNamed(context, "/home");
    } else {
      loader = false;
      streamController.add(DateTime.now().toIso8601String());
    }
  }

  loadConfigJson() async {
    String data = await rootBundle.loadString('assets/configs.json');
    AppConfig.shared = AppConfig.fromJson(json.decode(data));
  }
}

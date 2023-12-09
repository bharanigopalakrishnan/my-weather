import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:myweather/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends ChangeNotifier {
  User? userData;

  UserController({this.userData});

  void updateUser(User? user) {
    userData = user;
    saveCountToLocalStorage();
    notifyListeners();
  }

  Future<void> saveCountToLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
     userData != null?await prefs.setString('user',json.encode(userData!.toJson())): await prefs.remove('user');
  }

  Future<User?> loadCountFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user') != null) {
      userData = User.fromJson(json.decode(prefs.getString('user').toString()));
      inspect(userData);
      notifyListeners();
    }
    return userData;
  }
}

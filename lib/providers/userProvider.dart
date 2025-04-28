
import 'package:flutter/material.dart';
import 'package:neuro_learn/model/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    id: 0,
    name: '',
    email: '',
    password: '',
    confirmpas: '',
    phone: '',
    token: '',
  );

  User get user => _user;

  void setUser(String userJson) {
    // Log the raw user data for debugging
    debugPrint("+++++");
    debugPrint(userJson);
    debugPrint("+++++");

    // Parse the user JSON into a User object
    try {
      _user = User.fromJson(userJson);
      debugPrint("User successfully parsed: ${_user.toJson()}");
      notifyListeners();
    } catch (e) {
      debugPrint("Error parsing user data: $e");
    }
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }
}

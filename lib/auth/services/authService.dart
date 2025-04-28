
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:neuro_learn/common/global_varibale.dart';
import 'package:neuro_learn/providers/userProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Sign Up Function
  Future<bool> signUp({
    required String username,
    required String email,
    required String password,
    required String phone,
  }) async {
    final response = await http.post(
      Uri.parse('$uri/api/auth/signup'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "username": username,
        "email": email,
        "password": password,
        "phoneNumber": phone
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Signup successful: ${response.body}");
      return true;
    } else {
      print("Signup failed: ${response.body}");
      return false;
    }
  }

  // Login Function
  Future<void> login({
    required String email,
    required String password,
    required Function(bool) callback,
  }) async {
    print("Login attempt with email: $email and password: $password");
    final response = await http.post(
      Uri.parse('$uri/api/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];

      // Save token to SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      // print("Login successful, token saved.");
      callback(true);
    } else {
      print("Login failed: ${response.body}");
      callback(false);
    }
  }

  void updateUser(BuildContext context, dynamic userData) {
    Provider.of<UserProvider>(context, listen: false).setUser(userData["user"]);
  }

  // Get token from SharedPreferences
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }


void getUserData(BuildContext context) async {
    try {
      // Retrieve token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      debugPrint("Token retrieved: $token");

      // If token is null or empty, reset it and exit
      if (token == null || token.isEmpty) {
        prefs.setString('token', '');
        debugPrint("Token is null or empty, resetting...");
        return;  // Exit early as no token exists
      }

      // Validate token by calling the TokenisValid API
      var tokenRes = await http.post(
        Uri.parse('$uri/api/auth/TokenisValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'token': token
        },
      );

      // Decode response body
      var response = jsonDecode(tokenRes.body);
      debugPrint("Token validation response: $response");

      // Check if the response is a boolean and true
      if (response is bool && response == true) {
        // If token is valid, fetch user data
        http.Response userRes = await http.get(
          Uri.parse('$uri/api/auth/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'token': token
          },
        );

        // Debug print the user data response
        debugPrint("User data response: ${userRes.body}");

        // Parse the user data
        var userData = jsonDecode(userRes.body);

        // Ensure that the token is not overwritten with an empty string
        userData['token'] = token;  // Add the token back to the response if it was lost

        // Set the user data in the UserProvider
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(jsonEncode(userData));  // Set user data to trigger the UI update
      } else {
        // Token is invalid, so clear it from SharedPreferences
        debugPrint("Token is invalid.");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove('token');  // Clear invalid token
      }
    } catch (e) {
      debugPrint("Error getting user data: $e");
    }
  }
}

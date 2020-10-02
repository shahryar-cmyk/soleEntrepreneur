import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  int _userId;
  Timer _authTimer;
  List<dynamic> _userRole;
  String _userEmail;
  String _userNiceName;
  String _userDisplayName;
  String _userAvatar;
  String message;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      print(_userAvatar);
      return _token;
    }
    return null;
  }

  String get userAvatar {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _userAvatar;
    }
    return null;
  }

  int get userId {
    return _userId;
  }

  Future<void> authethicate(
    String email,
    String password,
  ) async {
    try {
      final url = 'https://soleentrepreneur.co.uk/wp-json/jwt-auth/v1/token';
      final response = await http.post(
        url,
        body: {
          'username': email,
          'password': password,
        },
      );
      print(
        json.decode(response.body),
      );
      final responseData = json.decode(response.body);
      if (responseData['message'] != null) {
        throw HttpException(responseData['message']);
      }
      _token = responseData['token'];
      _userEmail = responseData['user_email'];
      _userNiceName = responseData['user_nicename'];
      _userDisplayName = responseData['user_display_name'];
      _userRole = responseData['user_role'];
      _userId = responseData['user_id'];
      _userAvatar = responseData['avatar'];
      _expiryDate = DateTime.now().add(new Duration(days: 7));
      notifyListeners();
      SharedPreferences pref = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
        'user_email': _userEmail,
        'user_nicename': _userNiceName,
        'user_display_name': _userDisplayName,
        'user_role': _userRole,
        'avatar': _userAvatar,
      });
      pref.setString('userData', userData);
    } catch (error) {
      throw (error);
    }
  }

  Future<void> signIn(String email, String password) async {
    await authethicate(email, password);
  }

  Future<void> register(String email, String password, String username,
      String firstName, String lastName) async {
    await registerAuth(email, username, password, firstName, lastName);
  }

  Future<void> registerAuth(String email, String username, String password,
      String firstName, String lastName) async {
    try {
      final registerUrl =
          'https://soleentrepreneur.co.uk/wp-json/wp/v2/users/register';
      final response = await http.post(registerUrl,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(
            {
              'username': username,
              'password': password,
              'email': email,
              'first_name': firstName,
              'last_name': lastName
            },
          ));

      final responseData = json.decode(response.body);

      if (responseData['code'] != 200) {
        throw HttpException(responseData['message']);
      }
      print(
        json.decode(response.body),
      );
      message = responseData['message'];
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> logOut() async {
    _userId = null;
    _token = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      print(_token);
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      print(_token);
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    _userEmail = extractedUserData['user_email'];
    _userDisplayName = extractedUserData['user_display_name'];
    _userNiceName = extractedUserData['user_nicename'];
    _userRole = extractedUserData['user_role'];
    _userAvatar = extractedUserData['avatar'];
    notifyListeners();
    _autoLogOut();
    print(_token);
    return true;
  }

  void _autoLogOut() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logOut);
  }
}

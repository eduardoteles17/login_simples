import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:login_simples/constants/shared_preferences.dart';
import 'package:login_simples/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'users_controller.dart';

class AuthController {
  final Future<SharedPreferences> _sharedPreferences = SharedPreferences.getInstance();
  final UsersController _usersController = UsersController.instance;

  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  AuthController._();

  static final AuthController instance = AuthController._();

  Future<bool> init() async {
    final prefs = await _sharedPreferences;
    final currentUser = prefs.getString(SharedPreferenceKeys.currentUser);
    if (currentUser != null) {
      _currentUser = _usersController.findUserById(currentUser);
      return true;
    }
    return false;
  }

  Future<bool> login(String username, String password) async {
    final user = _usersController.findUserByUsername(username);
    if (user == null) {
      return false;
    }

    final passwordHash = user.passwordHash;
    final inputPasswordHash = sha256.convert(utf8.encode(password)).toString();

    final successLogin = passwordHash == inputPasswordHash;

    if (!successLogin) {
      return false;
    }

    await _sharedPreferences.then((prefs) {
      prefs.setString(SharedPreferenceKeys.currentUser, user.id);
    });

    _currentUser = user;

    return true;
  }

  Future<void> logout() async {
    await _sharedPreferences.then((prefs) {
      prefs.remove(SharedPreferenceKeys.currentUser);
    });

    _currentUser = null;
  }
}

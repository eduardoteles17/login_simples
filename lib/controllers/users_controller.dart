import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:login_simples/constants/shared_preferences.dart';
import 'package:login_simples/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersController {
  final _sharedPreferences = SharedPreferences.getInstance();

  final List<UserModel> _users = [];

  UsersController._() {
    _sharedPreferences.then((prefs) {
      final usersJson = prefs.getString(SharedPreferenceKeys.users);
      if (usersJson != null) {
        final users = jsonDecode(usersJson) as List;
        _users.addAll(users.map((user) => UserModel.fromJson(user)));
      }
    });
  }

  static final UsersController instance = UsersController._();

  Future<void> createUser(String name, String password) async {
    final passwordHash = sha256.convert(utf8.encode(password)).toString();
    final user = UserModel(
      id: DateTime.now().toString(),
      username: name,
      passwordHash: passwordHash,
    );

    _users.add(user);

    await _sharedPreferences.then((prefs) async {
      final users = _users.map((user) => user.toJson()).toList();
      prefs.setString(SharedPreferenceKeys.users, jsonEncode(users));
    });
  }

  UserModel? findUserByUsername(String username) {
    try {
      return _users.firstWhere((user) => user.username == username);
    } catch (e) {
      return null;
    }
  }

  UserModel? findUserById(String id) {
    try {
      return _users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }
}

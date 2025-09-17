import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  String? _token;

  bool get isAuthenticated => _token != null;
  UserModel? get user => _user;

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return false;
    _token = token;
    addAuthInterceptor();
    notifyListeners();
    return true;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await AuthService().login(email, password);
    final token = res['token'] as String?;
    final userJson = res['user'] as Map<String, dynamic>?;
    if (token != null && userJson != null) {
      _token = token;
      _user = UserModel.fromJson(userJson);
      await AuthService.saveToken(token);
      addAuthInterceptor();
      notifyListeners();
      return {'success': true};
    }
    return {'success': false, 'message': res['message'] ?? 'Login failed'};
  }

  Future<Map<String, dynamic>> register(String name, String email, String password, String role) async {
    final res = await AuthService().register(name, email, password, role);
    final token = res['token'] as String?;
    final userJson = res['user'] as Map<String, dynamic>?;
    if (token != null && userJson != null) {
      _token = token;
      _user = UserModel.fromJson(userJson);
      await AuthService.saveToken(token);
      addAuthInterceptor();
      notifyListeners();
      return {'success': true};
    }
    return {'success': false, 'message': res['message'] ?? 'Registration failed'};
  }

  Future<void> logout() async {
    await AuthService.removeToken();
    _token = null;
    _user = null;
    notifyListeners();
  }

   void updateUser({required String name, required String email}) {
    if (_user != null) {
      _user = UserModel(
        id: _user!.id,
        name: name,
        email: email,
        role: _user!.role,
      );
      notifyListeners();
    }
  }

  String? get token => _token;
}
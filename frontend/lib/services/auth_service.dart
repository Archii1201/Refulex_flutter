import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api.dart';

class AuthService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await dio.post('/api/auth/login', data: {'email': email, 'password': password});
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> register(String name, String email, String password, String role) async {
    final res = await dio.post('/api/auth/register', data: {'name': name, 'email': email, 'password': password, 'role': role});
    return res.data as Map<String, dynamic>;
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    addAuthInterceptor();
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
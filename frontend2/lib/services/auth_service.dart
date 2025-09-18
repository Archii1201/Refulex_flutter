import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api.dart';

// final Dio dio = Dio(BaseOptions(baseUrl: API_BASE_URL));

class AuthService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await dio.post(
      '/api/auth/login',
      data: {'email': email, 'password': password},
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> register(
  String name,
  String email,
  String password,
  String role,
  double lat,
  double lng,
) async {
  final res = await dio.post(
    '/api/auth/register',
    data: {
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'lat': lat,
      'lng': lng,
    },
  );
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

  // ✅ NEW: Update user profile
  Future<Map<String, dynamic>> updateUser(String userId, Map<String, dynamic> updates) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final res = await dio.put(
      "/api/users/$userId",
      data: updates,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return res.data as Map<String, dynamic>;
  }
}

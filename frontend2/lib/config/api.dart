import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

String get baseUrl => dotenv.env['API_BASE_URL'] ?? 'http://10.0.2.2:5001';

Dio get dio => Dio(BaseOptions(baseUrl: baseUrl));

void addAuthInterceptor() {
  dio.interceptors.clear();
  dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }));
}
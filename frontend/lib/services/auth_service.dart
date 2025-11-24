import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> register(
    String email,
    String username,
    String password,
  ) async {
    final response = await _apiService.post(
      '/auth/register',
      {
        'email': email,
        'username': username,
        'password': password,
      },
      includeAuth: false,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', response['token']);
    await prefs.setString('user', jsonEncode(response['user']));

    return response;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _apiService.post(
      '/auth/login',
      {
        'email': email,
        'password': password,
      },
      includeAuth: false,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', response['token']);
    await prefs.setString('user', jsonEncode(response['user']));

    return response;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
  }

  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null && token.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      // API에서 최신 유저 정보 가져오기
      final response = await _apiService.get(
        '/users/me',
        includeAuth: true,
      );
      
      // SharedPreferences에도 저장
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', jsonEncode(response));
      
      return response;
    } catch (e) {
      // API 실패시 캐시된 데이터 반환
      final prefs = await SharedPreferences.getInstance();
      final userString = prefs.getString('user');
      if (userString != null) {
        return jsonDecode(userString);
      }
      return null;
    }
  }
}

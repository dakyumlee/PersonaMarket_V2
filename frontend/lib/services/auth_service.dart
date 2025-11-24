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
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');
    if (userString != null) {
      return jsonDecode(userString);
    }
    return null;
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  Map<String, dynamic>? _user;
  bool _isAuthenticated = false;

  Map<String, dynamic>? get user => _user;
  bool get isAuthenticated => _isAuthenticated;

  AuthProvider() {
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    _isAuthenticated = await _authService.isAuthenticated();
    if (_isAuthenticated) {
      try {
        _user = await _authService.getCurrentUser();
      } catch (e) {
        print('Error loading user: $e');
        _user = null;
      }
    }
    notifyListeners();
  }

  Future<bool> register(String email, String username, String password) async {
    try {
      final response = await _authService.register(email, username, password);
      // 로그인 후 최신 유저 정보 가져오기
      _user = await _authService.getCurrentUser();
      _isAuthenticated = true;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await _authService.login(email, password);
      // 로그인 후 최신 유저 정보 가져오기
      _user = await _authService.getCurrentUser();
      _isAuthenticated = true;
      notifyListeners();
      return true;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}

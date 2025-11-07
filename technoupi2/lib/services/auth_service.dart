import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import '../models/user.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  // Register user
  static Future<Map<String, dynamic>> register({
    required String name,
    required String mobile,
    required String email,
    required String password,
  }) async {
    final data = {
      'name': name,
      'mobile': mobile,
      'email': email,
      'password': password,
    };

    return await ApiService.post('/api/auth/register', data);
  }

  // Login user
  static Future<Map<String, dynamic>> login({
    required String mobile,
    required String password,
  }) async {
    final data = {
      'mobile': mobile,
      'password': password,
    };

    final response = await ApiService.post('/api/auth/login', data);

    // Save token and user data
    if (response.containsKey('token') && response.containsKey('user')) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, response['token']);
      await prefs.setString(_userKey, jsonEncode(response['user']));
    }

    return response;
  }

  // Get stored token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Get stored user data
  static Future<User?> getStoredUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userKey);
    if (userData != null) {
      final userMap = jsonDecode(userData);
      return User.fromJson(userMap);
    }
    return null;
  }

  // Logout user
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  // Get user profile from API
  static Future<User> getProfile() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await ApiService.get('/api/user/profile', token: token);
    final user = User.fromJson(response);
    return user;
  }

  // Get user balance
  static Future<double> getBalance() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await ApiService.get('/api/balance', token: token);
    return response['balance'].toDouble();
  }
}

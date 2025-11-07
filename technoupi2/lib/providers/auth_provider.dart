import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = false;
  User? _currentUser;
  String? _token;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  User? get currentUser => _currentUser;
  String? get token => _token;

  // Login with mobile and password (after OTP verification)
  Future<void> login(String mobile, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await AuthService.login(mobile: mobile, password: password);

      _token = response['token'];
      _currentUser = User.fromJson(response['user']);
      _isAuthenticated = true;

      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }

    _isLoading = false;
    notifyListeners();
  }

  // Register new user
  Future<void> register({
    required String name,
    required String mobile,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await AuthService.register(
        name: name,
        mobile: mobile,
        email: email,
        password: password,
      );
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }

    _isLoading = false;
    notifyListeners();
  }

  // Logout user
  Future<void> logout() async {
    await AuthService.logout();
    _isAuthenticated = false;
    _currentUser = null;
    _token = null;
    notifyListeners();
  }

  // Check if user is already logged in (from persistent storage)
  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final isLoggedIn = await AuthService.isLoggedIn();
      if (isLoggedIn) {
        _token = await AuthService.getToken();
        _currentUser = await AuthService.getStoredUser();
        _isAuthenticated = true;
      }
    } catch (e) {
      // Handle error silently
      // Removed print for production
    }

    _isLoading = false;
    notifyListeners();
  }

  // Refresh user profile from API
  Future<void> refreshProfile() async {
    if (!_isAuthenticated || _token == null) return;

    try {
      _currentUser = await AuthService.getProfile();
      notifyListeners();
    } catch (e) {
      // Removed print for production
      // If token is invalid, logout
      if (e.toString().contains('401') || e.toString().contains('invalid')) {
        await logout();
      }
    }
  }

  // Update user balance
  Future<void> updateBalance() async {
    if (!_isAuthenticated) return;

    try {
      final balance = await AuthService.getBalance();
      if (_currentUser != null) {
        _currentUser = User(
          name: _currentUser!.name,
          mobile: _currentUser!.mobile,
          email: _currentUser!.email,
          upiId: _currentUser!.upiId,
          balance: balance,
        );
        notifyListeners();
      }
    } catch (e) {
      // Removed print for production
    }
  }

  // Set demo user for testing purposes
  void setDemoUser(User user) {
    _currentUser = user;
    _isAuthenticated = true;
    _token = 'demo_token';
    notifyListeners();
  }
}

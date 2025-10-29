import 'package:flutter/material.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  User? _currentUser;

  bool get isAuthenticated => _isAuthenticated;
  User? get currentUser => _currentUser;

  Future<void> login(String mobile, String otp) async {
    // Mock login - in real app, this would verify OTP
    await Future.delayed(const Duration(seconds: 2)); // Simulate API call

    if (otp == '123456') { // Mock OTP
      _isAuthenticated = true;
      _currentUser = User.mockUser;
      notifyListeners();
    } else {
      throw Exception('Invalid OTP');
    }
  }

  void logout() {
    _isAuthenticated = false;
    _currentUser = null;
    notifyListeners();
  }

  // Check if user is already logged in (from persistent storage)
  Future<void> checkAuthStatus() async {
    // Mock check - in real app, check token from storage
    await Future.delayed(const Duration(seconds: 1));
    // For demo, assume not logged in initially
  }
}

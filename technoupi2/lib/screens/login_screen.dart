import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _otpSent = false;
  bool _isLoading = false;
  int _resendTimer = 30;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _mobileController.text = '+91 '; // Pre-fill country code
  }

  void _sendOTP() {
    if (_mobileController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid mobile number')),
      );
      return;
    }

    setState(() {
      _otpSent = true;
      _canResend = false;
      _resendTimer = 30;
    });

    // Start countdown timer
    _startResendTimer();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP sent to your mobile number')),
    );
  }

  void _startResendTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _resendTimer > 0) {
        setState(() {
          _resendTimer--;
        });
        _startResendTimer();
      } else if (mounted) {
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  Future<void> _verifyOTP() async {
    if (_otpController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter 6-digit OTP')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.login(_mobileController.text, _otpController.text);

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              const Text(
                'Welcome to\nUPI Secure',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter your mobile number to continue',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 40),

              // Mobile Number Input
              TextField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
                  LengthLimitingTextInputFormatter(13), // +91 + 10 digits
                ],
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  hintText: '+91 9876543210',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                enabled: !_otpSent,
              ),

              const SizedBox(height: 20),

              // Send OTP Button
              if (!_otpSent) ...[
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _sendOTP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Send OTP',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ] else ...[
                // OTP Input
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Enter 6-digit OTP',
                    hintText: '123456',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),

                const SizedBox(height: 12),

                // Resend OTP
                Row(
                  children: [
                    const Text(
                      "Didn't receive OTP? ",
                      style: TextStyle(color: Color(0xFF6B7280)),
                    ),
                    TextButton(
                      onPressed: _canResend ? _sendOTP : null,
                      child: Text(
                        _canResend ? 'Resend' : 'Resend in ${_resendTimer}s',
                        style: TextStyle(
                          color: _canResend
                              ? const Color(0xFF2563EB)
                              : const Color(0xFF9CA3AF),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Verify OTP Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _verifyOTP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Verify OTP',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _otpController.dispose();
    super.dispose();
  }
}

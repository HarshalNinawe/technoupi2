import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../providers/auth_provider.dart';
import '../models/user.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser ?? User.mockUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F2937)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Center(
                      child: Text(
                        user.name[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Name
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // UPI ID Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'UPI ID',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          user.upiId,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.copy,
                          color: Color(0xFF2563EB),
                          size: 20,
                        ),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: user.upiId));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('UPI ID copied to clipboard')),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // QR Code Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    'Your QR Code',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
                      ],
                    ),
                    child: QrImageView(
                      data: 'upi://pay?pa=${user.upiId}&pn=${user.name}&cu=INR',
                      version: QrVersions.auto,
                      size: 180.0,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () {
                      // Handle share QR code
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Share QR code feature coming soon!')),
                      );
                    },
                    icon: const Icon(Icons.share, color: Color(0xFF2563EB)),
                    label: const Text(
                      'Share QR Code',
                      style: TextStyle(color: Color(0xFF2563EB)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Personal Information
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildInfoTile('Mobile Number', user.mobile, false),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildInfoTile('Email', user.email, false),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildInfoTile('Balance', '₹${user.balance.toStringAsFixed(2)}', false),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Logout Button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              height: 50,
              child: TextButton(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFFEE2E2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFDC2626),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, bool editable) {
    return ListTile(
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF6B7280),
        ),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFF1F2937),
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: editable
          ? const Icon(Icons.edit, color: Color(0xFF2563EB))
          : null,
      onTap: editable ? () {
        // Handle edit
      } : null,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              authProvider.logout();
              // Navigate to login screen
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFDC2626),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

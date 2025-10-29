import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';
import 'payment_screen.dart';
import 'bank_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import 'qr_scanner_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),
    const PaymentScreen(),
    const BankScreen(),
    const HistoryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Pay',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'Banks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF2563EB),
        unselectedItemColor: const Color(0xFF6B7280),
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const QrScannerScreen()),
          );
        },
        backgroundColor: const Color(0xFF2563EB),
        child: const Icon(Icons.qr_code_scanner, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser ?? User.mockUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                // Avatar
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    );
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        user.name[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // App Name
                const Expanded(
                  child: Text(
                    'UPI Secure',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ),
                // Notification Bell
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_none,
                        color: Color(0xFF1F2937),
                        size: 24,
                      ),
                      onPressed: () {
                        // Handle notification tap
                      },
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Balance Card
            Container(
              margin: const EdgeInsets.all(16),
              height: 120,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Balance',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₹${user.balance.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Spacer(),
                        const Text(
                          'Default: HDFC ••••7890',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 12),
                        TextButton(
                          onPressed: () {
                            // Handle add money
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Add Money',
                            style: TextStyle(
                              color: Color(0xFF2563EB),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Quick Actions
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildQuickAction(
                    icon: Icons.send,
                    label: 'Send',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const PaymentScreen()),
                      );
                    },
                  ),
                  _buildQuickAction(
                    icon: Icons.account_balance,
                    label: 'Bank',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const BankScreen()),
                      );
                    },
                  ),
                  _buildQuickAction(
                    icon: Icons.history,
                    label: 'History',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const HistoryScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Recent Activity
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const HistoryScreen()),
                          );
                        },
                        child: const Text(
                          'See All',
                          style: TextStyle(
                            color: Color(0xFF2563EB),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...mockTransactions.take(3).map((transaction) => _buildTransactionItem(transaction)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 32,
              color: const Color(0xFF2563EB),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF1F2937),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Text(
                transaction.name[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1F2937),
                  ),
                ),
                Text(
                  transaction.upiId,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          // Amount and Status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${transaction.type == TransactionType.sent ? '-' : '+'}₹${transaction.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: transaction.type == TransactionType.sent
                      ? const Color(0xFFDC2626)
                      : const Color(0xFF059669),
                ),
              ),
              const Icon(
                Icons.check_circle,
                size: 16,
                color: Color(0xFF059669),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

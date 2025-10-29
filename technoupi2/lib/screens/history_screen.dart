import 'package:flutter/material.dart';
import '../models/transaction.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Transaction> _getFilteredTransactions(String filter) {
    switch (filter) {
      case 'Sent':
        return mockTransactions
            .where((t) => t.type == TransactionType.sent)
            .toList();
      case 'Received':
        return mockTransactions
            .where((t) => t.type == TransactionType.received)
            .toList();
      default:
        return mockTransactions;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Payment History',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F2937)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF2563EB),
          unselectedLabelColor: const Color(0xFF6B7280),
          indicatorColor: const Color(0xFF2563EB),
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Sent'),
            Tab(text: 'Received'),
          ],
          onTap: (index) {
            setState(() {
              switch (index) {
                case 0:
                  _selectedFilter = 'All';
                  break;
                case 1:
                  _selectedFilter = 'Sent';
                  break;
                case 2:
                  _selectedFilter = 'Received';
                  break;
              }
            });
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Color(0xFF1F2937)),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTransactionList('All'),
          _buildTransactionList('Sent'),
          _buildTransactionList('Received'),
        ],
      ),
    );
  }

  Widget _buildTransactionList(String filter) {
    final transactions = _getFilteredTransactions(filter);

    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No ${filter.toLowerCase()} transactions',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      );
    }

    // Group transactions by date
    final groupedTransactions = <String, List<Transaction>>{};
    for (final transaction in transactions) {
      final dateKey = _formatDate(transaction.dateTime);
      if (!groupedTransactions.containsKey(dateKey)) {
        groupedTransactions[dateKey] = [];
      }
      groupedTransactions[dateKey]!.add(transaction);
    }

    return ListView.builder(
      itemCount: groupedTransactions.length,
      itemBuilder: (context, index) {
        final dateKey = groupedTransactions.keys.elementAt(index);
        final dayTransactions = groupedTransactions[dateKey]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFFF9FAFB),
              child: Text(
                dateKey,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                ),
              ),
            ),
            // Transactions for this date
            ...dayTransactions.map((transaction) => _buildTransactionItem(transaction)),
          ],
        );
      },
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Text(
                transaction.name[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Transaction Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 2),
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
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: transaction.type == TransactionType.sent
                      ? const Color(0xFFDC2626)
                      : const Color(0xFF059669),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    _formatTime(transaction.dateTime),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    transaction.status == TransactionStatus.success
                        ? Icons.check_circle
                        : transaction.status == TransactionStatus.pending
                            ? Icons.schedule
                            : Icons.error,
                    size: 14,
                    color: transaction.status == TransactionStatus.success
                        ? const Color(0xFF059669)
                        : transaction.status == TransactionStatus.pending
                            ? const Color(0xFFF59E0B)
                            : const Color(0xFFDC2626),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final transactionDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (transactionDate == today) {
      return 'Today';
    } else if (transactionDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${transactionDate.day} ${months[transactionDate.month - 1]} ${transactionDate.year}';
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final amPm = dateTime.hour >= 12 ? 'PM' : 'AM';
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute $amPm';
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Transactions'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('All Transactions'),
              value: 'All',
              groupValue: _selectedFilter,
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value!;
                });
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<String>(
              title: const Text('Sent Only'),
              value: 'Sent',
              groupValue: _selectedFilter,
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value!;
                });
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<String>(
              title: const Text('Received Only'),
              value: 'Received',
              groupValue: _selectedFilter,
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value!;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

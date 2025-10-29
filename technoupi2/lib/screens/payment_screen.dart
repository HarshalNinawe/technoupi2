import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  // Mock contact data
  final List<Map<String, String>> _contacts = [
    {'name': 'Alice Smith', 'number': '+91 9876543210', 'upiId': 'alice.smith@upi'},
    {'name': 'Bob Johnson', 'number': '+91 9876543211', 'upiId': 'bob.johnson@upi'},
    {'name': 'Charlie Brown', 'number': '+91 9876543212', 'upiId': 'charlie.brown@upi'},
    {'name': 'Diana Prince', 'number': '+91 9876543213', 'upiId': 'diana.prince@upi'},
    {'name': 'Eve Wilson', 'number': '+91 9876543214', 'upiId': 'eve.wilson@upi'},
  ];

  List<Map<String, String>> _filteredContacts = [];
  String? _selectedContact;

  @override
  void initState() {
    super.initState();
    _filteredContacts = _contacts;
    _searchController.addListener(_filterContacts);
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredContacts = _contacts.where((contact) {
        return contact['name']!.toLowerCase().contains(query) ||
               contact['number']!.contains(query) ||
               contact['upiId']!.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _selectContact(Map<String, String> contact) {
    setState(() {
      _selectedContact = contact['upiId'];
    });
  }

  void _makePayment() {
    if (_selectedContact == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a contact')),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    // Mock payment processing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment of ₹${amount.toStringAsFixed(2)} initiated to $_selectedContact')),
    );

    // Reset form
    setState(() {
      _selectedContact = null;
      _amountController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Make Payment',
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
      body: Column(
        children: [
          // Search Bar
          Container(
            margin: const EdgeInsets.all(16),
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
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Enter Mobile / Name / UPI ID',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF6B7280)),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),

          // Amount Input
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
                  'Amount',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  decoration: InputDecoration(
                    hintText: '₹0.00',
                    prefixIcon: const Icon(Icons.currency_rupee, color: Color(0xFF6B7280)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Pay Button
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _makePayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Pay',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Contact List
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.builder(
                itemCount: _filteredContacts.length,
                itemBuilder: (context, index) {
                  final contact = _filteredContacts[index];
                  final isSelected = _selectedContact == contact['upiId'];

                  return ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          contact['name']![0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      contact['name']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    subtitle: Text(
                      '${contact['number']} • ${contact['upiId']}',
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 12,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: Color(0xFF2563EB))
                        : null,
                    onTap: () => _selectContact(contact),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}

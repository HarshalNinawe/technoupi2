import 'package:flutter/material.dart';

class BankScreen extends StatelessWidget {
  const BankScreen({super.key});

  // Mock bank data
  final List<Map<String, dynamic>> _banks = const [
    {
      'name': 'HDFC Bank',
      'account': '••••7890',
      'logo': '🏦',
      'isDefault': true,
    },
    {
      'name': 'ICICI Bank',
      'account': '••••1234',
      'logo': '🏦',
      'isDefault': false,
    },
    {
      'name': 'SBI',
      'account': '••••5678',
      'logo': '🏦',
      'isDefault': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Linked Banks',
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
          // Bank List
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.builder(
                itemCount: _banks.length,
                itemBuilder: (context, index) {
                  final bank = _banks[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: index < _banks.length - 1
                          ? const Border(
                              bottom: BorderSide(
                                color: Color(0xFFF3F4F6),
                                width: 1,
                              ),
                            )
                          : null,
                    ),
                    child: Row(
                      children: [
                        // Bank Logo
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              bank['logo'],
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Bank Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    bank['name'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF1F2937),
                                    ),
                                  ),
                                  if (bank['isDefault']) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFDBEAFE),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'Default',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Color(0xFF2563EB),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Account ${bank['account']}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Menu Icon
                        IconButton(
                          icon: const Icon(
                            Icons.more_vert,
                            color: Color(0xFF6B7280),
                          ),
                          onPressed: () {
                            // Show bank options menu
                            _showBankOptions(context, bank);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // Add New Bank Button
          Container(
            margin: const EdgeInsets.all(16),
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: () {
                // Handle add new bank
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Add new bank feature coming soon!')),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF2563EB)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '+ Link New Bank',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF2563EB),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBankOptions(BuildContext context, Map<String, dynamic> bank) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              bank['name'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.star_border, color: Color(0xFF2563EB)),
              title: const Text('Set as Default'),
              onTap: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${bank['name']} set as default')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.visibility_off, color: Color(0xFF6B7280)),
              title: const Text('Hide Account'),
              onTap: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Account hidden')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Color(0xFFDC2626)),
              title: const Text('Remove Bank'),
              onTap: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${bank['name']} removed')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

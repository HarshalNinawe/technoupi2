class Transaction {
  final String id;
  final String name;
  final String upiId;
  final double amount;
  final DateTime dateTime;
  final TransactionType type;
  final TransactionStatus status;

  Transaction({
    required this.id,
    required this.name,
    required this.upiId,
    required this.amount,
    required this.dateTime,
    required this.type,
    required this.status,
  });

  // Factory constructor to create Transaction from JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['_id'] ?? '',
      name: json['recipient_name'] ?? json['sender_name'] ?? 'Unknown',
      upiId: json['recipient_upi'] ?? json['sender_upi'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      dateTime: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      type: json['type'] == 'sent' ? TransactionType.sent : TransactionType.received,
      status: _parseStatus(json['status'] ?? 'pending'),
    );
  }

  // Convert Transaction to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'recipient_name': name,
      'recipient_upi': upiId,
      'amount': amount,
      'timestamp': dateTime.toIso8601String(),
      'type': type == TransactionType.sent ? 'sent' : 'received',
      'status': status.toString().split('.').last,
    };
  }

  static TransactionStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'success':
        return TransactionStatus.success;
      case 'failed':
        return TransactionStatus.failed;
      default:
        return TransactionStatus.pending;
    }
  }
}

enum TransactionType {
  sent,
  received,
}

enum TransactionStatus {
  success,
  pending,
  failed,
}

extension TransactionTypeExtension on TransactionType {
  String get displayName {
    switch (this) {
      case TransactionType.sent:
        return 'Sent';
      case TransactionType.received:
        return 'Received';
    }
  }
}

extension TransactionStatusExtension on TransactionStatus {
  String get displayName {
    switch (this) {
      case TransactionStatus.success:
        return 'Success';
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.failed:
        return 'Failed';
    }
  }
}

// Mock transaction data
List<Transaction> mockTransactions = [
  Transaction(
    id: '1',
    name: 'Alice Smith',
    upiId: 'alice.smith@upi',
    amount: 500.00,
    dateTime: DateTime.now().subtract(const Duration(hours: 2)),
    type: TransactionType.sent,
    status: TransactionStatus.success,
  ),
  Transaction(
    id: '2',
    name: 'Bob Johnson',
    upiId: 'bob.johnson@upi',
    amount: 1200.00,
    dateTime: DateTime.now().subtract(const Duration(days: 1)),
    type: TransactionType.received,
    status: TransactionStatus.success,
  ),
  Transaction(
    id: '3',
    name: 'Charlie Brown',
    upiId: 'charlie.brown@upi',
    amount: 250.00,
    dateTime: DateTime.now().subtract(const Duration(days: 2)),
    type: TransactionType.sent,
    status: TransactionStatus.success,
  ),
];

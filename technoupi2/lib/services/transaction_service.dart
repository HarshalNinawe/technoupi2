import '../models/transaction.dart';
import 'api_service.dart';
import 'auth_service.dart';

class TransactionService {
  // Send money to recipient
  static Future<Map<String, dynamic>> sendMoney({
    required String recipientUpi,
    required double amount,
  }) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final data = {
      'recipient_upi': recipientUpi,
      'amount': amount.toString(),
    };

    return await ApiService.postWithAuth('/api/transactions/send', data, token);
  }

  // Get transaction history
  static Future<List<Transaction>> getTransactionHistory() async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await ApiService.get('/api/transactions/history', token: token);

    final transactions = response['transactions'] as List;
    return transactions.map((tx) => Transaction.fromJson(tx)).toList();
  }
}

class ApiConfig {
  // Change this to your backend URL
  static const String baseUrl = 'http://localhost:5000';

  // API Endpoints
  static const String register = '/api/auth/register';
  static const String login = '/api/auth/login';
  static const String profile = '/api/user/profile';
  static const String sendMoney = '/api/transactions/send';
  static const String transactionHistory = '/api/transactions/history';
  static const String balance = '/api/balance';
  static const String health = '/api/health';
}

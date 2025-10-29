class User {
  final String name;
  final String mobile;
  final String email;
  final String upiId;
  final double balance;

  User({
    required this.name,
    required this.mobile,
    required this.email,
    required this.upiId,
    required this.balance,
  });

  // Mock user data
  static User mockUser = User(
    name: 'John Doe',
    mobile: '+91 9876543210',
    email: 'john.doe@example.com',
    upiId: 'john.doe@secure',
    balance: 5420.00,
  );
}

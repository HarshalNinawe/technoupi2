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

  // Factory constructor to create User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      mobile: json['mobile'] ?? '',
      email: json['email'] ?? '',
      upiId: json['upi_id'] ?? '',
      balance: (json['balance'] ?? 0.0).toDouble(),
    );
  }

  // Convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mobile': mobile,
      'email': email,
      'upi_id': upiId,
      'balance': balance,
    };
  }

  // Mock user data (for fallback)
  static User mockUser = User(
    name: 'John Doe',
    mobile: '+91 9876543210',
    email: 'john.doe@example.com',
    upiId: 'john.doe@secure',
    balance: 5420.00,
  );
}

enum UserType { customer, dev }

class UserModel {
  final String email;
  final String password;
  final UserType type;
  final String name;

  UserModel({
    required this.email,
    required this.password,
    required this.type,
    this.name = '',
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'type': type.name,
    'name': name,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    email: json['email'] ?? '',
    password: json['password'] ?? '',
    type: json['type'] == 'dev' ? UserType.dev : UserType.customer,
    name: json['name'] ?? '',
  );
}
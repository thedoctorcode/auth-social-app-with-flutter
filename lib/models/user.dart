class User {
  final String name;
  final String email;
  final String token;

  User({
    required this.name,
    required this.email,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json['name'],
        email: json['email'],
        token: json['token'],
      );

  Map<String, dynamic> get toJson => {
        'name': name,
        'email': email,
        'token': token,
      };

  String get initials =>
      name.split(' ').map((word) => word.substring(0, 1).toUpperCase()).join();
}

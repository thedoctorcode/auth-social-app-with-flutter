class SignInRequest {
  final String email;
  final String password;

  SignInRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> get toJson => {
        'email': email,
        'password': password,
      };
}

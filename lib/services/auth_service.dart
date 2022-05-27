import 'dart:convert';

import 'package:social_appl/models/sign_in_request.dart';
import 'package:social_appl/models/sign_up_request.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<User> signIn(SignInRequest request) async {
    final response = await http.post(
      Uri.parse('https://servatedb.vercel.app/api/fudeo-flutter-2-focus/login'),
      headers: {
        'Content-type': 'application/json; charset=utf-8',
      },
      body: jsonEncode(request.toJson),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }

    throw Exception('Errore nel sign in');
  }

  Future<User> signUp(SignUpRequest request) async {
    final response = await http.post(
      Uri.parse(
          'https://servatedb.vercel.app/api/fudeo-flutter-2-focus/register'),
      headers: {
        'Content-type': 'application/json; charset=utf-8',
      },
      body: jsonEncode(request.toJson),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }

    throw Exception('Errore nel sign up');
  }
}

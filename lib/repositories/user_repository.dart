import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:social_appl/models/sign_in_request.dart';
import 'package:social_appl/models/sign_up_request.dart';
import 'package:social_appl/services/auth_service.dart';

import '../models/user.dart';

class UserRepository {
  final AuthService authService;
  final FlutterSecureStorage secureStorage;
  final Logger logger;

  UserRepository({
    required this.authService,
    required this.logger,
    required this.secureStorage,
  });

  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final user = await authService.signIn(
        SignInRequest(email: email, password: password),
      );

      final encodedJson = user.toJson;
      final json = jsonEncode(encodedJson);

      await secureStorage.write(
        key: 'CURRENT_USER',
        value: json,
      );

      return user;
    } catch (error, stackTrace) {
      logger.e(
        'Errore nell\'autenticarsi con email: $email e password: $password',
        error,
        stackTrace,
      );

      rethrow;
    }
  }

  Future<User> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = await authService
          .signUp(SignUpRequest(name: name, email: email, password: password));
      return user;
    } catch (error, stackTrace) {
      logger.e(
        'Errore nel registrare un nuovo utente di nome $name, email: $email, password: $password',
        error,
        stackTrace,
      );

      rethrow;
    }
  }

  Future<void> signOut() async {
    await secureStorage.delete(key: 'CURRENT_USER');
  }

  Future<User?> get currentUser async {
    final json = await secureStorage.read(key: "CURRENT_USER");

    if (json != null) {
      final decodedJson = jsonDecode(json);
      return User.fromJson(decodedJson);
    }
  }
}

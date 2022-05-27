import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:social_appl/cubits/auth/cubit/auth_cubit.dart';
import 'package:social_appl/pages/main_page.dart';
import 'package:social_appl/pages/welcome_page.dart';
import 'package:provider/provider.dart';
import 'package:social_appl/repositories/user_repository.dart';
import 'package:social_appl/services/auth_service.dart';
import 'package:social_appl/services/image_picker_service.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          Provider(
            create: (_) => ImagePickerService(),
          ),
          Provider(
            create: (_) => AuthService(),
          ),
          Provider(
            create: (_) => Logger(),
          ),
          Provider(
            create: (_) => const FlutterSecureStorage(),
          ),
        ],
        child: RepositoryProvider(
          create: (context) => UserRepository(
            authService: context.read(),
            secureStorage: context.read(),
            logger: context.read(),
          ),
          child: BlocProvider(
            create: (context) => AuthCubit(
              userRepository: context.read(),
            )..checkAuthenticationState(),
            child: MaterialApp(
              title: 'Social App',
              home: MainPage(),
              debugShowCheckedModeBanner: false,
            ),
          ),
        ),
      );
}

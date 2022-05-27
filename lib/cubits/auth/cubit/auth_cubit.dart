import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_appl/repositories/user_repository.dart';

import '../../../models/user.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final UserRepository userRepository;

  AuthCubit({required this.userRepository}) : super(CheckAuthenticatedState());

  void checkAuthenticationState() async {
    final user = await userRepository.currentUser;

    emit(user != null ? AuthenticatedState(user) : NotAuthenticatedState());
  }

  void authenticated(User user) => emit(AuthenticatedState(user));

  void logOut() async {
    await userRepository.signOut();
    emit(NotAuthenticatedState());
  }
}

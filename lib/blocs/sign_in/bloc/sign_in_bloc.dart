import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_appl/cubits/auth/cubit/auth_cubit.dart';
import 'package:social_appl/repositories/user_repository.dart';

import '../../../models/user.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final UserRepository userRepository;
  final AuthCubit authCubit;

  SignInBloc({
    required this.userRepository,
    required this.authCubit,
  }) : super(NotSignedInState()) {
    on<SignInEvent>((event, emit) async {
      emit(SigningInState());

      User? user;
      try {
        user = await userRepository.signIn(
          email: event.email,
          password: event.password,
        );
      } catch (e) {
        emit(SignInErrorState());
      }

      if (user != null) {
        authCubit.authenticated(user);
        emit(SignedInState(user));
      }
    });
  }

  void signIn({
    required String email,
    required String password,
  }) =>
      add(
        SignInEvent(
          email: email,
          password: password,
        ),
      );
}

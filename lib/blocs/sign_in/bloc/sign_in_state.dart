part of 'sign_in_bloc.dart';

abstract class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object> get props => [];
}

class NotSignedInState extends SignInState {}

class SigningInState extends SignInState {}

class SignedInState extends SignInState {
  final User user;

  const SignedInState(this.user);

  @override
  List<Object> get props => [user];
}

class SignInErrorState extends SignInState {}

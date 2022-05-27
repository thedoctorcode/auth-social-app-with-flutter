part of 'sign_up_bloc.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

class NotSignedUpState extends SignUpState {}

class SigningUpState extends SignUpState {}

class SignedUpState extends SignUpState {
  final User user;

  const SignedUpState(this.user);

  @override
  List<Object> get props => [user];
}

class SignUpErrorState extends SignUpState {}

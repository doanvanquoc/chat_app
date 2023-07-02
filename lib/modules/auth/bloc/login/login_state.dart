part of 'login_bloc.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class Logining extends LoginState {}

class LoginError extends LoginState {
  final String error;

  LoginError({required this.error});
}

class LoginSuccess extends LoginState {}

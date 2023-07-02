
part of 'register_bloc.dart';

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterError extends RegisterState {
  final String error;
  RegisterError({required this.error});
}

class RegisterSuccess extends RegisterState {}

import 'dart:developer';

import 'package:chat_app/modules/auth/service/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(Logining());
      try {
        await authService.signInWithEmailAndPassword(
            event.email, event.password);
        emit(LoginSuccess());
        log('emit successs');
      } catch (e) {
        emit(LoginError(error: e.toString()));
      }
    });
  }
}

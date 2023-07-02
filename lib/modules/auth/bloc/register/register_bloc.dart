import 'package:chat_app/modules/auth/service/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterEvent>((event, emit) async {
      emit(RegisterLoading());
      try {
        await authService.createUserWithEmailAndPassword(
          event.email,
          event.password,
        );
        emit(RegisterSuccess());
        await authService.saveUserData(event.email);
      } catch (e) {
        emit(RegisterError(error: e.toString()));
      }
    });
  }
}

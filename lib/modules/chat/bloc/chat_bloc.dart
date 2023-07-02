import 'package:chat_app/modules/chat/services/chat_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<ChatEvent>((event, emit) async {
      emit(ChatSending());
      try {
        await chatService.sendMessage(event.receiverID, event.message);
        emit(ChatSendSuccess());
      } catch (e) {
        emit(ChatSendError(error: e.toString()));
      }
    });
  }
}

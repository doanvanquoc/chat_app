part of 'chat_bloc.dart';

class ChatEvent {
  final String message;
  final String receiverID;
  ChatEvent({
    required this.message,
    required this.receiverID,
  });
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'chat_bloc.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatSending extends ChatState {}

class ChatSendError extends ChatState {
  final String error;
  ChatSendError({
    required this.error,
  });
}

class ChatSendSuccess extends ChatState {}

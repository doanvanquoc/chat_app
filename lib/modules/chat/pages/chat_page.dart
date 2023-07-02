import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/components/my_text_field.dart';
import 'package:chat_app/modules/chat/bloc/chat_bloc.dart';
import 'package:chat_app/modules/chat/services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(
      {super.key, required this.receiverEmail, required this.receiverID});
  final String receiverEmail;
  final String receiverID;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //controller
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  //firebase auth
  final _auth = FirebaseAuth.instance;

  //build method
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.receiverEmail),
        ),
        body: Column(
          children: [
            Expanded(child: _buildMessageList()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: _messageController,
                      hintText: 'Send a message',
                      textInputAction: TextInputAction.send,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      BlocProvider.of<ChatBloc>(context).add(
                        ChatEvent(
                          message: _messageController.text,
                          receiverID: widget.receiverID,
                        ),
                      );
                      _messageController.clear();
                      FocusScope.of(context).unfocus();
                    },
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  //build message list
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isSender = data['senderID'] == _auth.currentUser!.uid;
    //Canh lề message theo người gửi và người nhận
    var alignment = isSender ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            isSender ? 'You' : data['senderEmail'],
          ),
          const SizedBox(height: 3),
          ChatBubble(
            color: isSender ? Colors.blueAccent : Colors.grey,
            alignment: alignment,
            message: data['message'],
          ),
        ],
      ),
    );
  }

  //build message item
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: chatService.getMessage(_auth.currentUser!.uid, widget.receiverID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.hasData) {
          //Tự động cuộn xuống tin nhắn cuối cùng :v
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent);
          });

          //Return danh sách tin nhắn
          return ListView.builder(
            controller: _scrollController,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return _buildMessageItem(snapshot.data!.docs[index]);
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}

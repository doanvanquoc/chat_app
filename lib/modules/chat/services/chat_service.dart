import 'package:chat_app/modules/chat/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  //singleton
  static final _service = ChatService._internal();

  factory ChatService() => _service;

  ChatService._internal();

  //instance
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  //Send message
  Future<void> sendMessage(String receiverID, message) async {
    //Get current user
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    //Create message
    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );

    //Create chat room from userID and veceiverID (sorted)
    List<String> ids = [currentUserID, receiverID];
    ids.sort(); // Để chắc chắn rằng id là duy nhất cho dù thay đổi thứ tự các phần tử trong mảng
    String chatRoomId = ids.join('_');

    //add new message to database
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('message')
        .add(
          newMessage.toMap(),
        );
  }

  //Get message
  Stream<QuerySnapshot> getMessage(String userID, String otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('message')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}

final chatService = ChatService();

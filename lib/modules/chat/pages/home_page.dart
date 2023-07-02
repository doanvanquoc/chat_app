import 'package:chat_app/modules/auth/pages/login_page.dart';
import 'package:chat_app/modules/auth/service/auth_service.dart';
import 'package:chat_app/modules/chat/pages/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //get current user
  final user = authService.getCurrentUser();

  //Sign out method
  void signOut() async {
    await FirebaseAuth.instance.signOut();
    popToLoginPage();
  }

  //Pop to login Page
  void popToLoginPage() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
        centerTitle: true,
        title: const Text('Danh sách người dùng'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(child: _buildUserList()),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('user').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Text('Loading....'),
          );
        }
        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildUserListItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
    if (user!.email != data['email']) {
      return Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                    receiverEmail: data['email'], receiverID: data['uid']),
              ),
            );
          },
          title: Text(data['email']),
        ),
      );
    }
    return const SizedBox();
  }
}

import 'package:chat_app/modules/auth/pages/login_page.dart';
import 'package:chat_app/modules/auth/service/auth_service.dart';
import 'package:chat_app/modules/chat/pages/home_page.dart';
import 'package:flutter/material.dart';

class CheckLogin extends StatefulWidget {
  const CheckLogin({super.key});

  @override
  State<CheckLogin> createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> {
  final user = authService.getCurrentUser();
  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const LoginPage();
    } else {
      return const HomePage();
    }
  }
}

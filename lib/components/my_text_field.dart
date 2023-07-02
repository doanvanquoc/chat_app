import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.controller,
    this.obscure = false,
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    required this.hintText,
  });
  final TextEditingController controller;
  final bool obscure;
  final String hintText;
  final TextInputType textInputType;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      textInputAction: textInputAction,
      keyboardType: textInputType,
      decoration: InputDecoration(
        
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade200,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        fillColor: Colors.grey[100],
        filled: true,
      ),
    );
  }
}

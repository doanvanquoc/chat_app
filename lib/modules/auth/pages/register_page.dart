import 'dart:developer';

import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_text_field.dart';
import 'package:chat_app/modules/auth/bloc/register/register_bloc.dart';
import 'package:chat_app/modules/chat/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: BlocListener<RegisterBloc, RegisterState>(
          listener: (context, state) {
            //Loading khi đang register
            if (state is RegisterLoading) {
              log('loading');
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: ((context) => const Center(
                      child: CircularProgressIndicator(),
                    )),
              );
            }
            //Hiện lỗi nếu có
            if (state is RegisterError) {
              //Ẩn vòng loading
              log('error');
              Navigator.pop(context);

              //Ẩn Snackbar trước
              ScaffoldMessenger.of(context).clearSnackBars();

              //Hiện thông báo lỗi
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                ),
              );
            }
            //Hiện thông báo đăng ký thành công
            if (state is RegisterSuccess) {
              //Ẩn vòng loading
              Navigator.pop(context);
              log('test');

              //Hiện thông báo thành công
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đăng ký thành công'),
                  duration: Duration(seconds: 1),
                ),
              );
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false);
            }
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //Logo
                    Image.asset(
                      'assets/images/404.png',
                      width: 200,
                      height: 200,
                    ),
                    //Lời chào
                    Text(
                      'Đăng Ký',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 30),
                    //Email texxtfield
                    MyTextField(
                        controller: _emailController, hintText: 'Nhập email'),
                    //Password textfield

                    const SizedBox(height: 10),
                    MyTextField(
                      controller: _passwordController,
                      hintText: 'Nhập mật khẩu',
                      obscure: true,
                    ),
                    const SizedBox(height: 10),
                    MyTextField(
                      controller: _confirmPasswordController,
                      hintText: 'Xác nhận mật khẩu',
                      obscure: true,
                    ),
                    //Sign in button
                    const SizedBox(height: 20),
                    MyButton(
                      onTap: () {
                        BlocProvider.of<RegisterBloc>(context).add(
                          RegisterEvent(
                            email: _emailController.text,
                            password: _passwordController.text,
                          ),
                        );
                        FocusScope.of(context).unfocus();
                      },
                      text: 'Đăng ký',
                      color: Colors.blue.shade400,
                    ),
                    //Register text
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Đã có tài khoản? '),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: const Text(
                            'Đăng nhập ngay',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

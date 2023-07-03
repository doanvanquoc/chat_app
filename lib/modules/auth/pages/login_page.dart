import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_text_field.dart';
import 'package:chat_app/modules/auth/bloc/login/login_bloc.dart';
import 'package:chat_app/modules/auth/pages/register_page.dart';
import 'package:chat_app/modules/chat/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //build method
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is Logining) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => Center(
                  child: Lottie.asset('assets/loading.json'),
                ),
              );
            }
            if (state is LoginError) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                ),
              );
            }
            if (state is LoginSuccess) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đăng nhập thành công'),
                  duration: Duration(seconds: 1),
                ),
              );
              //Chuyển sang màn đăng nhập
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
                      'Đăng Nhập',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 30),
                    //Email texxtfield
                    MyTextField(
                      controller: _emailController,
                      hintText: 'Nhập email',
                      textInputType: TextInputType.emailAddress,
                    ),
                    //Password textfield

                    const SizedBox(height: 10),
                    MyTextField(
                      controller: _passwordController,
                      hintText: 'Nhập mật khẩu',
                      obscure: true,
                      textInputAction: TextInputAction.done,
                    ),
                    //Sign in button
                    const SizedBox(height: 20),
                    MyButton(
                      onTap: () {
                        BlocProvider.of<LoginBloc>(context).add(
                          LoginEvent(
                            email: _emailController.text,
                            password: _passwordController.text,
                          ),
                        );
                        FocusScope.of(context).unfocus();
                      },
                      text: 'Đăng Nhập',
                      color: Colors.blue.shade400,
                    ),
                    //Register text
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Chưa có tài khoản? '),
                        InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            ),
                          ),
                          child: const Text(
                            'Đăng ký ngay',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
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

import 'package:arml_messanger/utils/components/reusable_button.dart';
import 'package:arml_messanger/utils/components/reusable_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_services.dart';

class LoginPage extends StatefulWidget {
  final void Function() onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void signIn() async {
    final authService = Provider.of<AuthServices>(context, listen: false);

    try {
      await authService.singInWithEmail(
          email: _emailController.text.toString(),
          password: _passwordController.text.toString());
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.message,
                  size: 100.sp,
                  color: Colors.grey[800],
                ),
                SizedBox(
                  height: 50.h,
                ),
                Text(
                  "Welcome Back to ARML CHAT",
                  style: TextStyle(
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                ReusableTextField(
                  controller: _emailController,
                  hintText: "Enter Your Email",
                  obscureText: false,
                ),
                SizedBox(
                  height: 10.h,
                ),
                ReusableTextField(
                  controller: _passwordController,
                  hintText: "Enter Password",
                  obscureText: true,
                ),
                SizedBox(
                  height: 25.h,
                ),
                ReusableButton(
                  onTap: signIn,
                  text: "Sign In",
                ),
                SizedBox(
                  height: 50.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Not a member"),
                    SizedBox(
                      width: 4.w,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Register Now",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

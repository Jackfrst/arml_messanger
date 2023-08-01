import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_services.dart';
import '../../utils/components/reusable_button.dart';
import '../../utils/components/reusable_text_field.dart';

class SignUpScreen extends StatefulWidget {
  final void Function() onTap;

  const SignUpScreen({super.key, required this.onTap});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _userFirstNameController = TextEditingController();
  TextEditingController _userLastNameController = TextEditingController();

  void signUp() async {
    final authService = Provider.of<AuthServices>(context, listen: false);

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords must match"),
        ),
      );
      return;
    }

    try {
      await authService.singUpWithEmail(
        email: _emailController.text,
        password: _passwordController.text,
        firstName: _userFirstNameController.text,
        lastName: _userLastNameController.text,
        context: context,
      );
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
            child: Column(children: [
              Expanded(
                  child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  SizedBox(
                    height: 70.h,
                  ),
                  Icon(
                    Icons.message,
                    size: 100.sp,
                    color: Colors.grey[800],
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  Text(
                    "JOIN ARML CHAT",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ReusableTextField(
                          controller: _userFirstNameController,
                          hintText: "First Name",
                          obscureText: false,
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        child: ReusableTextField(
                          controller: _userLastNameController,
                          hintText: "Last Name",
                          obscureText: false,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
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
                    height: 10.h,
                  ),
                  ReusableTextField(
                    controller: _confirmPasswordController,
                    hintText: "Confirm Password",
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  ReusableButton(
                    onTap: signUp,
                    text: "Sign Up",
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already a Member?"),
                      SizedBox(
                        width: 4.w,
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          "Sign In",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                ],
              )),
            ]),
          ),
        ),
      ),
    );
  }
}

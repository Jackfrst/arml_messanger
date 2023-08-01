import 'package:arml_messanger/screens/authentication_screens/login_page.dart';
import 'package:arml_messanger/screens/authentication_screens/signUp_screen.dart';
import 'package:flutter/material.dart';

class LoginOrSignUp extends StatefulWidget {
  const LoginOrSignUp({super.key});

  @override
  State<LoginOrSignUp> createState() => _LoginOrSignUpState();
}

class _LoginOrSignUpState extends State<LoginOrSignUp> {
  bool showLogInPage = true;

  void togglePages(){
    setState(() {
      showLogInPage = !showLogInPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showLogInPage){
      return LoginPage(onTap: togglePages);
    }else{
      return SignUpScreen(onTap: togglePages);
    }
  }
}

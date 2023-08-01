import 'package:arml_messanger/screens/authentication_screens/login_or_signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../home_screens.dart';

class AuthenticateGateway extends StatefulWidget {
  const AuthenticateGateway({super.key});

  @override
  State<AuthenticateGateway> createState() => _AuthenticateGatewayState();
}

class _AuthenticateGatewayState extends State<AuthenticateGateway> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.hasData){
           return HomeScreen();
          }else{
            return LoginOrSignUp();
          }
        },
      ),
    );
  }
}

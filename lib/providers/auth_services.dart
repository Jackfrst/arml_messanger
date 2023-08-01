import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'firebase_provider.dart';

class AuthServices extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserCredential> singUpWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final _firestoreService = Provider.of<FirebaseProvider>(context, listen: false);

      _firestoreService.createUserInDatabase(userCredential: userCredential, email: email, firstName: firstName, lastName: lastName);

      return userCredential;
    } on FirebaseAuthException catch (error) {
      throw Exception(error.code);
    }

  }

  Future<UserCredential> singInWithEmail(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      return userCredential;
    } on FirebaseAuthException catch (error) {
      throw Exception(error.code);
    }
  }

  Future<void> singOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}

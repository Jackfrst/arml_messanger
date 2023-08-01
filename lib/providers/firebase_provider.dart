import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class FirebaseProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUserInDatabase({
    required UserCredential userCredential,
    required String email,
    required String firstName,
    required String lastName,
  }) async {
    _firestore.collection('users').doc(userCredential.user!.uid).set({
      'uid': userCredential.user!.uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
    });
  }
}

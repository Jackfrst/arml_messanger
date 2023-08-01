import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../utils/models/message_model.dart';

class ChatServiceProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Send Massage
  Future<void> sendMessage(
      {required String receiverId, required String message}) async {
    // Get a reference to the 'users' collection in Firestore
    CollectionReference<Map<String, dynamic>> usersCollection = _firestore.collection('users');

    // Fetch the document for the given UID
    DocumentSnapshot<Map<String, dynamic>> userData =
        await usersCollection.doc(_firebaseAuth.currentUser?.uid).get();

    print(userData);

    //get user info
    final String currentUserId = userData['uid'];
    final String currentUserEmail = userData['email'];
    final String currentUserName = "${userData['firstName']} ${userData['lastName']}";
    final Timestamp timestamp = Timestamp.now();

    //create massage
    MessageModel newMessage = MessageModel(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      senderName: currentUserName,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
    );

    //construct chat room id from userId and receiverId
    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    //add massage to database
    await _firestore
        .collection('chat_room')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toJson());
  }

  //Get Massage
  Stream<QuerySnapshot> getMessages(
      {required String userId, required String receiverId}) {
    List<String> ids = [userId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore
        .collection('chat_room')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}

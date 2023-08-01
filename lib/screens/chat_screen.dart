import 'package:arml_messanger/utils/components/chat_bubble.dart';
import 'package:arml_messanger/utils/components/reusable_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/chat_services.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverId;
  final String receiverName;

  const ChatPage(
      {super.key,
      required this.receiverEmail,
      required this.receiverId,
      required this.receiverName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatServiceProvider _chatService = ChatServiceProvider();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final _scrollController = ScrollController();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        receiverId: widget.receiverId,
        message: _messageController.text,
      );
      _messageController.clear();
      Future.delayed(const Duration(milliseconds: 1)).then((_) {
        _scrollDown(); // Scroll to the latest message
      });
    }
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
        title: Text(widget.receiverName),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput(),
          SizedBox(height: 25,),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
        stream: _chatService.getMessages(
            userId: _firebaseAuth.currentUser!.uid,
            receiverId: widget.receiverId,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("OPPs! ${snapshot.hasError}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text("Loading..."),
            );
          } else {
            var messages = snapshot.data!.docs
                .map<Widget>((doc) => _buildMessageItem(document: doc))
                .toList();

            var reversedMessages = messages.reversed.toList();

            return ListView(
              controller: _scrollController,
              reverse: true,
              physics: BouncingScrollPhysics(),
              children: reversedMessages,
            );
          }
        },
    );
  }

  Widget _buildMessageItem({required DocumentSnapshot document}) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    var alignmentColumn = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;

    DateTime dateTime = data['timestamp'].toDate();
    DateTime today = DateTime.now();

    String messageTime;

    if (dateTime.day == today.day &&
        dateTime.month == today.month &&
        dateTime.year == today.year) {
      messageTime = DateFormat('hh:mm a').format(dateTime);
    } else {
      messageTime = DateFormat('dd MMMM hh:mm a').format(dateTime);
    }

    return Container(
      alignment: alignment,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: alignmentColumn,
          children: [
            Text(data['senderName']),
            SizedBox(height: 5,),
            ChatBubble(message: data['message']),
            SizedBox(height: 5,),
            Text(messageTime),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Expanded(
            child: ReusableTextField(
              controller: _messageController,
              hintText: 'Type Your Message',
              obscureText: false,
            ),
          ),
          IconButton(
              onPressed: sendMessage,
              icon: Icon(
                Icons.arrow_upward,
                size: 40,
              )),
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/chat_bubble.dart';
import '../components/my_textfield.dart';
import '../services/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverUid;
  const ChatPage(
      {super.key, required this.receiverEmail, required this.receiverUid});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController listViewScrollController = ScrollController();
  final ChatService chatService = ChatService();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await chatService.sendMessage(widget.receiverUid, messageController.text);
      messageController.clear();
    }
    listViewScrollController
        .jumpTo(listViewScrollController.position.maxScrollExtent);
    //listViewScrollController.animateTo(
    //  listViewScrollController.position.maxScrollExtent,
    //  duration: Duration(seconds: 1),
    //  curve: Curves.fastOutSlowIn,
    //);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color.fromARGB(255, 52, 51, 51),
      appBar: AppBar(
        title: Text(widget.receiverEmail),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Expanded(
            child: buildMessageList(),
          ),
          buildMessageInput(),
          const SizedBox(
            height: 25,
          )
        ],
      ),
    );
  }

  Widget buildMessageList() {
    //print("buildMessageList()");
    return StreamBuilder(
        stream: chatService.getMessages(
            widget.receiverUid, firebaseAuth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error ${snapshot.error}");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading ...");
          }
          Timer(
              const Duration(milliseconds: 500),
              //() => listViewScrollController.animateTo(
              //      listViewScrollController.position.maxScrollExtent + 100,
              //      duration: Duration(seconds: 1),
              //      curve: Curves.fastOutSlowIn,
              //    ));
              () => listViewScrollController
                  .jumpTo(listViewScrollController.position.maxScrollExtent));
          ListView listView = ListView(
              //reverse: true,
              controller: listViewScrollController,
              children: snapshot.data!.docs
                  .map((document) => buildMessageItem(document))
                  .toList());

          //listViewScrollController.animateTo(
          // listViewScrollController.position.maxScrollExtent,
          // duration: Duration(seconds: 2),
          // curve: Curves.fastOutSlowIn,
          //);
          return listView;
        });
  }

  Widget buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    bool myMessage = (data['senderId'] == firebaseAuth.currentUser!.uid);
    var alignment = myMessage ? Alignment.centerRight : Alignment.centerLeft;
    var backgroundColor = myMessage
        ? const Color.fromARGB(255, 0, 141, 207)
        : const Color.fromARGB(255, 72, 78, 76);

    return Container(
        alignment: alignment,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                crossAxisAlignment: myMessage
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(data['senderEmail']),
                  const SizedBox(
                    height: 5,
                  ),
                  ChatBubble(
                    message: data['message'],
                    backgroundColor: backgroundColor,
                  )
                ])));
  }

  Widget buildMessageInput() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Row(children: [
          Expanded(
              child: MyTextField(
                  onGo: sendMessage,
                  controller: messageController,
                  hintText: "Message",
                  obscureText: false)),
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(Icons.arrow_upward, size: 40),
          )
        ]));
  }
}

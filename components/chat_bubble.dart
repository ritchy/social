import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final Color foregroundColor;
  const ChatBubble(
      {super.key,
      required this.message,
      this.backgroundColor = Colors.blue,
      this.foregroundColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: backgroundColor),
        child: Text(message,
            style: const TextStyle(fontSize: 16, color: Colors.white)));
  }
}

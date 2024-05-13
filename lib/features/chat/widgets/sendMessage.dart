import 'package:chat_app/core/formatDate/convertDate.dart';
import 'package:chat_app/models/chatMessageModel.dart';
import 'package:flutter/material.dart';

class SendMessageCard extends StatelessWidget {
  final ChatMessageModel message;
  const SendMessageCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return ListTile(
      title: Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(message.textMessage),
              Text(
                ConvertDateTime.convertTimeStampToReadable(
                  timestamp: message.sendTime,
                ),
                style: TextStyle(fontSize: w * 0.024, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

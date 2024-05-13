import 'package:chat_app/core/formatDate/convertDate.dart';
import 'package:chat_app/models/chatMessageModel.dart';
import 'package:flutter/material.dart';

class ReplyCard extends StatelessWidget {
  final ChatMessageModel message;
  const ReplyCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return ListTile(
      title: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          margin: EdgeInsets.symmetric(horizontal: w * 0.02),
          decoration: BoxDecoration(
            color: Colors.red[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.textMessage,
                style: TextStyle(fontSize: w * 0.04, color: Colors.black),
              ),
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

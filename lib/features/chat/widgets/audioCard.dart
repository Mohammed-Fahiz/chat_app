import 'package:chat_app/core/formatDate/convertDate.dart';
import 'package:chat_app/models/chatMessageModel.dart';
import 'package:flutter/material.dart';

class AudioMessage extends StatelessWidget {
  final bool isSender;
  final ChatMessageModel message;

  const AudioMessage(
      {super.key, required this.message, required this.isSender});
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.height;
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * .02, vertical: h * .015),
        child: Container(
          width: w * 0.35,
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: isSender ? Colors.grey[300] : Colors.red[100],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.play_arrow,
                    color: Colors.black,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * .02),
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Container(
                              width: double.infinity,
                              height: 2,
                              color: Colors.black),
                          Positioned(
                            left: 0,
                            child: Container(
                              height: 8,
                              width: 8,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const Text(
                    "0.37",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Text(
                ConvertDateTime.convertTimeStampToReadable(
                  timestamp: message.sendTime,
                ),
                style: TextStyle(fontSize: w * 0.012, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

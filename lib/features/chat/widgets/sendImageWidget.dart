import 'package:chat_app/core/formatDate/convertDate.dart';
import 'package:chat_app/core/utilities/customImagePopUp.dart';
import 'package:chat_app/core/utilities/custom_cahced_image.dart';
import 'package:chat_app/models/chatMessageModel.dart';
import 'package:flutter/material.dart';

class SendImageWidget extends StatelessWidget {
  final ChatMessageModel message;
  const SendImageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return CustomImagePopUpBox(imageUrl: message.imageMessage);
            },
          );
        },
        child: Padding(
          padding:
              EdgeInsets.symmetric(vertical: h * 0.01, horizontal: w * 0.06),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(w * 0.03),
            ),
            child: Padding(
              padding:
                  EdgeInsets.fromLTRB(w * 0.01, w * 0.01, w * 0.01, w * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: h * 0.2,
                    width: h * 0.2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(w * 0.03)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(w * 0.03),
                      child: CustomCachedNetworkImage(
                        imageUrl: message.imageMessage,
                      ),
                    ),
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
        ),
      ),
    );
  }
}

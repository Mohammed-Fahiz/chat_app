import 'package:chat_app/core/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageInputWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final void Function() sendMessage;
  final void Function() attachment;

  const MessageInputWidget(
      {super.key,
      required this.sendMessage,
      required this.textEditingController,
      required this.attachment});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      height: h * 0.08,
      width: w * 0.96,
      alignment: Alignment.topCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            height: h * 0.06,
            width: w * 0.82,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: w * 0.001),
                borderRadius: BorderRadius.circular(w * 0.06)),
            child: Row(
              children: [
                SizedBox(width: w * 0.01),
                Container(
                  height: h * 0.045,
                  width: h * 0.045,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: w * 0.001),
                  ),
                  child: IconButton(
                    onPressed: () => attachment(),
                    icon: Icon(
                      Icons.attach_file,
                      size: w * 0.05,
                    ),
                  ),
                ),
                SizedBox(width: w * 0.01),
                Expanded(
                  child: TextFormField(
                    controller: textEditingController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none),
                  ),
                ),
                SizedBox(width: w * 0.01),
              ],
            ),
          ),
          SizedBox(width: w * 0.02),
          GestureDetector(
            onTap: () => sendMessage(),
            child: CircleAvatar(
              radius: w * 0.06,
              backgroundColor: Palette.primaryColor,
              child: Icon(
                Icons.send,
                size: w * 0.05,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

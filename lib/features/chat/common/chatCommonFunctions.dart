import 'dart:io';

import 'package:chat_app/core/global_functions.dart';
import 'package:chat_app/core/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ChatCommonFunctions {
  static Future<XFile?> sendAttachment({required BuildContext context}) async {
    return await GlobalFunction().showImagePickerModal(context: context);
  }

  static Future<void> showImageBeforeSend({
    required XFile pickedImage,
    required Future<void> Function() sendImage,
    required Function() cancelImage,
    required BuildContext context,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        double h = MediaQuery.of(context).size.height;
        double w = MediaQuery.of(context).size.width;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: h * 0.4,
              child: Image.file(
                File(pickedImage.path),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: h * 0.02),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);

                await sendImage();
              },
              child: const Text("SEND"),
            )
          ],
        );
      },
    );
  }

  static Future<int?> messagePaginationDialog({
    required BuildContext context,
    required String content,
    required String pos,
    required currentLimit,
  }) async {
    final selectedValue = StateProvider<int?>((ref) => currentLimit);
    final limitList = [7, 14, 30, 365];

    return await showDialog<int?>(
      context: context,
      builder: (BuildContext context) {
        double h = MediaQuery.of(context).size.height;
        double w = MediaQuery.of(context).size.width;
        return Consumer(
          builder: (context, ref, child) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(w * 0.05),
              ),
              backgroundColor: Palette.backgroundColor,
              content: SizedBox(
                width: w * 0.7,
                child: Padding(
                  padding: EdgeInsets.only(top: h * 0.02),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        content,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Urbanist',
                          fontSize: w * 0.04,
                        ),
                      ),
                      SizedBox(
                        height: h * .3,
                        child: ListView.builder(
                          itemCount: limitList.length,
                          itemBuilder: (context, index) {
                            final limit = limitList[index];
                            return ListTile(
                              title: Text("$limit days"),
                              leading: Radio<int>(
                                value: limitList[index],
                                groupValue: ref.watch(selectedValue),
                                onChanged: (value) {
                                  ref.read(selectedValue.notifier).state =
                                      limitList[index];
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(w * 0.24, h * 0.03),
                    backgroundColor: Palette.backgroundColor,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(null); // Returning null
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Urbanist',
                      fontSize: w * 0.033,
                      color: Colors.black,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(w * 0.3, h * 0.03),
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Urbanist',
                      fontSize: w * 0.033,
                    ),
                    backgroundColor: Palette.primaryColor,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(
                      ref.read(selectedValue),
                    ); // Returning selected priority
                  },
                  child: Text(
                    pos,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  static String getChatDocId(
      {required String senderId, required String receiverId}) {
    return senderId.compareTo(receiverId) < 0
        ? '$senderId _ $receiverId'
        : '$receiverId _ $senderId';
  }
}

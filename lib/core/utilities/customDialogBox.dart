import 'package:flutter/material.dart';

import '../theme/theme.dart';

Future<bool?> showCustomDialogBox(
    {required BuildContext context, required String content}) async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Palette.backgroundColor,
        title:
            const Text("Alert!", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              content,
              style: const TextStyle(
                fontSize: 18,
              ),
            )
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Palette.buttonColor,
            ),
            onPressed: () {
              Navigator.of(context).pop(false); // Returning false
            },
            child: const Text(
              "No",
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Palette.buttonColor,
            ),
            onPressed: () {
              Navigator.of(context).pop(true); // Returning true
            },
            child: const Text(
              "Yes",
            ),
          ),
        ],
      );
    },
  );
}

Future<bool?> showCustomAlertDialog({
  required BuildContext context,
  required String content,
  required String pos,
  bool? hideCancelButton,
}) async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      double h = MediaQuery.of(context).size.height;
      double w = MediaQuery.of(context).size.width;
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(w * 0.05)),
        backgroundColor: Palette.backgroundColor,
        content: SizedBox(
          width: w * 0.7,
          child: Padding(
            padding: EdgeInsets.only(top: h * 0.02),
            child: Text(
              content,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Urbanist',
                fontSize: w * 0.04,
              ),
            ),
          ),
        ),
        actions: [
          if (hideCancelButton != true)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(w * 0.24, h * 0.03),
                backgroundColor: Palette.backgroundColor,
              ),
              onPressed: () {
                Navigator.of(context).pop(false); // Returning false
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Urbanist',
                    fontSize: w * 0.033,
                    color: Colors.black),
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
              Navigator.of(context).pop(true); // Returning true
            },
            child: Text(
              pos,
            ),
          ),
        ],
      );
    },
  );
}

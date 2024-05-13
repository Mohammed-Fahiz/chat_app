import 'dart:io';

import 'package:chat_app/core/theme/theme.dart';
import 'package:chat_app/core/utilities/customDialogBox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class GlobalFunction {
  Future<XFile?> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      return pickedFile;
    } else {
      return null;
    }
  }

  Future<XFile?> showImagePickerModal({required BuildContext context}) async {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        var w = MediaQuery.of(context).size.width;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Text(
                  'Select Photo From',
                  style:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: w * .05),
                ),
              ),
              const Divider(
                endIndent: 30,
                indent: 30,
                thickness: 2,
              ),
              ListTile(
                leading: const Icon(CupertinoIcons.photo_on_rectangle,
                    color: Palette.buttonColor),
                title: const Text(
                  'Gallery',
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
                ),
                onTap: () async {
                  await pickImage(ImageSource.gallery).then((value) {
                    Navigator.pop(context, value);
                  });
                },
              ),
              ListTile(
                leading: const Icon(
                  CupertinoIcons.camera_on_rectangle,
                  color: Palette.buttonColor,
                ),
                title: const Text(
                  'Camera',
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
                ),
                onTap: () async {
                  bool permissionGranted = false;
                  await Permission.camera.status.then((cameraStatus) async {
                    if (!cameraStatus.isGranted) {
                      await Permission.camera
                          .request()
                          .then((cameraStatus) async {
                        if (!cameraStatus.isGranted) {
                          showCustomAlertDialog(
                            context: context,
                            content: "Camera permission denied",
                            pos: "Settings",
                            hideCancelButton: true,
                          ).then((value) {
                            if (value != null && value == true) {
                              openAppSettings();
                            }
                          });
                        } else {
                          permissionGranted = true;
                        }
                      });
                    } else {
                      permissionGranted = true;
                    }

                    if (permissionGranted == true) {
                      await pickImage(ImageSource.camera).then((value) {
                        Navigator.pop(context, value);
                      });
                    }
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

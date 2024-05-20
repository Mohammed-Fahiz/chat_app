import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class AudioServices {
  static Future<String> getAudioPath() async {
    try {
      final appDir = Platform.isIOS
          ? await getApplicationDocumentsDirectory()
          : await getExternalStorageDirectory();
      final audioFilePath = "${appDir!.path}/audio.aac";
      return audioFilePath;
    } catch (e) {
      print("ERROR ${e.toString()}");
      return "";
    }
  }

  static Future<void> startRecording(
      {required FlutterSoundRecorder recorder,
      required String? audioFilePath}) async {
    await recorder.openRecorder();
    await recorder.startRecorder(
      toFile: audioFilePath,
    );
  }

  static Future<void> stopRecording({
    required FlutterSoundRecorder recorder,
  }) async {
    await recorder.stopRecorder();
    await recorder.closeRecorder();
  }

  static Future<PermissionStatus> requestPermissions() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
    }
    return status;
  }

  static Future<bool> checkFileExists({required String? audioFilePath}) async {
    try {
      return await File(audioFilePath!).exists();
    } catch (e) {
      return false;
    }
  }

  static Future<void> clearAudio({required String? audioFilePath}) async {
    try {
      if (await File(audioFilePath!).exists()) {
        await File(audioFilePath).delete();
        print('Audio file deleted: $audioFilePath');
      }
    } catch (e) {
      print('Error deleting audio file: $e');
    }
  }
}

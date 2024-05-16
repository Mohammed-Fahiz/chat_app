import 'package:chat_app/core/theme/theme.dart';
import 'package:chat_app/features/chat/services/audio_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class MessageInputWidget extends ConsumerStatefulWidget {
  final TextEditingController textEditingController;
  final void Function() sendMessage;
  final void Function() attachment;

  const MessageInputWidget(
      {super.key,
      required this.sendMessage,
      required this.textEditingController,
      required this.attachment});

  @override
  ConsumerState<MessageInputWidget> createState() => _MessageInputWidgetState();
}

class _MessageInputWidgetState extends ConsumerState<MessageInputWidget> {
  final FlutterSoundRecorder recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer player = FlutterSoundPlayer();
  final isRecordingProvider = StateProvider<bool>((ref) => false);
  final isPlayingProvider = StateProvider<bool>((ref) => false);
  final isAudioExistsProvider = StateProvider<bool>((ref) => false);
  String? audioFilePath;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    audioFilePath = await AudioServices.getAudioPath();
  }

  @override
  void dispose() {
    AudioServices.stopRecording(recorder: recorder);
    AudioServices.stopPlaying(player: player);
    AudioServices.clearAudio(audioFilePath: audioFilePath!);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      height: h * 0.08,
      width: w * 0.96,
      alignment: Alignment.topCenter,
      child: Consumer(
        builder: (context, ref, child) {
          final isRecording = ref.watch(isRecordingProvider);
          final isAudioExists = ref.watch(isAudioExistsProvider);
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () async => await record(isRecording: isRecording),
                child: CircleAvatar(
                  radius: w * 0.06,
                  backgroundColor: Palette.primaryColor,
                  child: Icon(
                    !isRecording ? Icons.keyboard_voice_sharp : Icons.close,
                    size: w * 0.05,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: w * 0.01),
              !isAudioExists
                  ? Container(
                      height: h * 0.06,
                      width: w * 0.69,
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.black, width: w * 0.001),
                          borderRadius: BorderRadius.circular(w * 0.06)),
                      child: Row(
                        children: [
                          SizedBox(width: w * 0.01),
                          Container(
                            height: h * 0.045,
                            width: h * 0.045,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.black, width: w * 0.001),
                            ),
                            child: IconButton(
                              onPressed: () => widget.attachment(),
                              icon: Icon(
                                Icons.attach_file,
                                size: w * 0.05,
                              ),
                            ),
                          ),
                          SizedBox(width: w * 0.01),
                          Expanded(
                            child: TextFormField(
                              controller: widget.textEditingController,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Type here....",
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none),
                            ),
                          ),
                          SizedBox(width: w * 0.01),
                        ],
                      ),
                    )
                  : IconButton(
                      onPressed: () async => await AudioServices.playRecording(
                        audioFilePath: audioFilePath,
                        player: player,
                      ),
                      icon: const Icon(Icons.play_arrow),
                    ),
              SizedBox(width: w * 0.02),
              GestureDetector(
                onTap: () => widget.sendMessage(),
                child: CircleAvatar(
                  radius: w * 0.06,
                  backgroundColor: Palette.primaryColor,
                  child: Icon(
                    Icons.send,
                    size: w * 0.05,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Future<void> record({required bool isRecording}) async {
    if (!isRecording) {
      await AudioServices.requestPermissions().then((status) async {
        if (status.isDenied || status.isPermanentlyDenied) {
          openAppSettings();
        } else if (status.isGranted) {
          await AudioServices.startRecording(
            audioFilePath: audioFilePath,
            recorder: recorder,
          ).then((value) {
            ref.read(isRecordingProvider.notifier).state = true;
          });
        }
      });
    } else {
      await AudioServices.stopRecording(recorder: recorder).then((value) async {
        ref.read(isRecordingProvider.notifier).state = false;
        await AudioServices.checkFileExists(audioFilePath: audioFilePath).then(
            (value) => ref.read(isAudioExistsProvider.notifier).state = value);
      });
    }
  }
}

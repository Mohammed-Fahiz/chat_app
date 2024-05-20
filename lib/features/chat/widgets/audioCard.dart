import 'package:chat_app/core/formatDate/convertDate.dart';
import 'package:chat_app/models/chatMessageModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';

class AudioMessage extends StatefulWidget {
  final bool isSender;
  final ChatMessageModel message;

  const AudioMessage(
      {super.key, required this.message, required this.isSender});

  @override
  State<AudioMessage> createState() => _AudioMessageState();
}

class _AudioMessageState extends State<AudioMessage> {
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  FlutterSoundPlayer player = FlutterSoundPlayer();

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    if (widget.message.audioMessage != "") {
      await player.openPlayer();
      player.setSubscriptionDuration(const Duration(milliseconds: 10));
      player.onProgress!.listen((e) {
        setState(() {
          _position = e.position;
          _duration = e.duration;
        });
      });
    }
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await player.pausePlayer();
    } else {
      await player.startPlayer(
        fromURI: widget.message.audioMessage,
        codec: Codec.aacADTS,
        whenFinished: () {
          setState(() {
            _isPlaying = false;
            _position = Duration.zero;
          });
        },
      );
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  void dispose() {
    player.closePlayer();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.height;
    return Align(
      alignment: widget.isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * .02, vertical: h * .015),
        child: Container(
          width: w * 0.35,
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: widget.isSender ? Colors.grey[300] : Colors.red[100],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.black,
                    ),
                    onPressed: _togglePlayPause,
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
                            color: Colors.black,
                          ),
                          Positioned(
                            left: (_position.inMilliseconds /
                                    (_duration.inMilliseconds == 0
                                        ? 1
                                        : _duration.inMilliseconds)) *
                                w *
                                0.31,
                            child: Container(
                              height: 8,
                              width: 8,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    _formatDuration(_position),
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Text(
                ConvertDateTime.convertTimeStampToReadable(
                  timestamp: widget.message.sendTime,
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

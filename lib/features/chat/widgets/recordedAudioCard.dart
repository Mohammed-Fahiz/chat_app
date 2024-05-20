import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

class RecordedAudioCard extends StatefulWidget {
  final String? audioFilePath;

  const RecordedAudioCard({
    super.key,
    required this.audioFilePath,
  });

  @override
  RecordedAudioCardState createState() => RecordedAudioCardState();
}

class RecordedAudioCardState extends State<RecordedAudioCard> {
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
    if (widget.audioFilePath != null) {
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
        fromURI: widget.audioFilePath,
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
    double w = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0).copyWith(left: 8),
      child: Container(
        height: h * 0.08,
        width: w * 0.67,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.grey[300],
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
          ],
        ),
      ),
    );
  }
}

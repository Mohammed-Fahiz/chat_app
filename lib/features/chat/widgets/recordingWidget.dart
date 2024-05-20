import 'dart:async';
import 'package:flutter/material.dart';

class RecordingAnimationWidget extends StatefulWidget {
  final bool isRecording;

  const RecordingAnimationWidget({Key? key, required this.isRecording})
      : super(key: key);

  @override
  _RecordingAnimationWidgetState createState() =>
      _RecordingAnimationWidgetState();
}

class _RecordingAnimationWidgetState extends State<RecordingAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Timer? _timer;
  int _startTime = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween(begin: 1.0, end: 1.5).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    if (widget.isRecording) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _startTime++;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _startTime = 0;
  }

  @override
  void didUpdateWidget(covariant RecordingAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording && !oldWidget.isRecording) {
      _startTimer();
    } else if (!widget.isRecording && oldWidget.isRecording) {
      _stopTimer();
    }
  }

  String _formattedTime() {
    final minutes = _startTime ~/ 60;
    final seconds = _startTime % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ScaleTransition(
          scale: _animation,
          child: const Icon(
            Icons.settings_voice,
            color: Colors.red,
          ),
        ),
        Text(
          "Recording.... ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Urbanist',
            fontSize: w * 0.05,
          ),
        ),
        Text(
          _formattedTime(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Urbanist',
            fontSize: w * 0.05,
          ),
        ),
      ],
    );
  }
}

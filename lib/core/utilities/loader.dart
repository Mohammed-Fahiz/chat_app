import 'package:chat_app/core/theme/theme.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: Palette.buttonColor,
      ),
    );
  }
}

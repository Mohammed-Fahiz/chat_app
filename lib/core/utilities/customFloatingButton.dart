import 'package:flutter/material.dart';

import '../theme/theme.dart';

class CustomFloatingButton extends StatelessWidget {
  final void Function() onTap;
  final String text;
  const CustomFloatingButton(
      {super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: w * 0.91,
        height: h * 0.07,
        decoration: BoxDecoration(
            color: Palette.primaryColor,
            borderRadius: BorderRadius.circular(w * 0.04)),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontFamily: 'Urbanist',
                color: Colors.white,
                fontSize: w * 0.04,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

showSnackBar(
    {required String content,
    required BuildContext context,
    required Color color,
    bool? delay}) {
  final snackBar = SnackBar(
    content: Text(
      content,
      textAlign: TextAlign.center,
      style: const TextStyle(
          letterSpacing: 2, fontWeight: FontWeight.bold, fontSize: 13),
    ),
    backgroundColor: color,
  );
  if (delay != true) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

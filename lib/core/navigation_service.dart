import 'package:flutter/cupertino.dart';

class NavigationService {
  static navigateToScreen(
      {required BuildContext context, required Widget screen}) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  static navigateRemoveUntil(
      {required BuildContext context, required Widget screen}) {
    Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
          builder: (context) => screen,
        ),
        (route) => false);
  }

  static navigatePushReplacement(
      {required BuildContext context, required Widget screen}) {
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(
        builder: (context) => screen,
      ),
    );
  }
}

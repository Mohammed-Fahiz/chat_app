import 'package:chat_app/core/navigation_service.dart';
import 'package:chat_app/core/utilities/loader.dart';
import 'package:chat_app/features/auth/controller/auth_controller.dart';
import 'package:chat_app/features/auth/screens/sign_in_screen.dart';
import 'package:chat_app/features/chat/screens/chatTileScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    navigateUser();
    super.initState();
  }

  Future<void> navigateUser() async {
    await Future.delayed(
      const Duration(seconds: 3),
      () {
        SharedPreferences.getInstance().then((prefs) async {
          final userId = prefs.getString("userId");
          if (userId != null) {
            await ref
                .read(authControllerProvider.notifier)
                .getUserData(context: context, userId: userId)
                .then((value) {
              NavigationService.navigateRemoveUntil(
                context: context,
                screen: const ChatTileScreen(),
              );
            });
          } else {
            NavigationService.navigateRemoveUntil(
              context: context,
              screen: const SignInScreen(),
            );
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Loader(),
      ),
    );
  }
}

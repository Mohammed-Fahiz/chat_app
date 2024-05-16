import 'package:chat_app/core/theme/theme.dart';
import 'package:chat_app/features/auth/screens/sign_in_screen.dart';
import 'package:chat_app/features/auth/screens/splash_screen.dart';
import 'package:chat_app/features/chat/screens/chatTileScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Palette.lightModeAppTheme,
      home: const SplashScreen(),
    );
  }
}

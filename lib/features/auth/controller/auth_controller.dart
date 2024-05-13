import 'package:chat_app/models/userModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider = NotifierProvider<AuthController, bool>(
  () => AuthController(),
);

final userProvider = StateProvider<UserModel?>((ref) => null);
final fcmTokenProvider = StateProvider<String?>((ref) => null);

class AuthController extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }
}

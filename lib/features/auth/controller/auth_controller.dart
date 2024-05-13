import 'package:chat_app/core/imageStorage/controller/imageStorageController.dart';
import 'package:chat_app/core/navigation_service.dart';
import 'package:chat_app/core/theme/theme.dart';
import 'package:chat_app/core/utilities/custom_snackBar.dart';
import 'package:chat_app/features/auth/repository/auth_repository.dart';
import 'package:chat_app/features/chat/screens/chatTileScreen.dart';
import 'package:chat_app/models/userModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

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

  Future<void> signUpWithEmailAndPassword(
      {required String password,
      required UserModel userModel,
      required BuildContext context,
      required XFile? imageFile}) async {
    state = true;

    final res =
        await ref.read(authRepositoryProvider).signUpWithEmailAndPassword(
              userModel: userModel,
              password: password,
            );
    state = false;
    res.fold(
      (l) => showSnackBar(
        content: l.errMSg,
        context: context,
        color: Palette.snackBarErrorColor,
      ),
      (userModel) async {
        await storeUserDataLocally(userModel: userModel, context: context)
            .then((value) async {
          await addUserImage(
            context: context,
            imageFile: imageFile,
            userModel: userModel,
          );
        }).then((value) {
          NavigationService.navigateRemoveUntil(
            context: context,
            screen: const ChatTileScreen(),
          );
        });

        ref.read(userProvider.notifier).state = userModel;
      },
    );
  }

  Future<void> signInWithEmailAndPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    state = true;
    final res =
        await ref.read(authRepositoryProvider).signInWithEmailAndPassword(
              email: email,
              password: password,
            );

    state = false;

    res.fold(
      (l) => showSnackBar(
        content: l.errMSg,
        context: context,
        color: Palette.snackBarErrorColor,
      ),
      (userModel) async {
        await storeUserDataLocally(userModel: userModel, context: context)
            .then((value) {
          NavigationService.navigateRemoveUntil(
            context: context,
            screen: const ChatTileScreen(),
          );
        });
        return ref.read(userProvider.notifier).state = userModel;
      },
    );
  }

  Future<void> addUserImage(
      {required XFile? imageFile,
      required UserModel userModel,
      required BuildContext context}) async {
    UserModel user = userModel;
    if (imageFile != null) {
      state = true;
      await ref.read(imageStorageController.notifier).uploadImageToStorage(
            imageFile: imageFile,
            context: context,
            folderName: "users",
            fileName:
                "${userModel.name}-${DateTime.now().millisecondsSinceEpoch}",
          );
      user = user.copyWith(userImage: ref.read(imageUrlProvider));
      ref.read(imageUrlProvider.notifier).update((state) => null);

      await ref.read(authRepositoryProvider).addUserImage(userModel: user);
      state = false;
    }
  }

  Future<void> getUserData(
      {required BuildContext context, required String userId}) async {
    state = true;
    final res =
        await ref.read(authRepositoryProvider).getUserData(userId: userId);
    state = false;
    res.fold(
      (l) => showSnackBar(
          content: l.errMSg,
          context: context,
          color: Palette.snackBarErrorColor),
      (userModel) => ref.read(userProvider.notifier).state = userModel,
    );
  }

  Future<void> storeUserDataLocally(
      {required UserModel userModel, required BuildContext context}) async {
    final res = await ref
        .read(authRepositoryProvider)
        .storeUserDataLocally(userModel: userModel);
    res.fold(
        (l) => showSnackBar(
            content: l.errMSg,
            context: context,
            color: Palette.snackBarErrorColor),
        (r) => null);
  }
}

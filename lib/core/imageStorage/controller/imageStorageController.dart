import 'package:chat_app/core/imageStorage/repository/imageStorageRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/theme.dart';
import '../../utilities/custom_snackBar.dart';

final imageUrlProvider = StateProvider<String?>((ref) => null);

final imageStorageController = NotifierProvider<ImageStorageController, bool>(
  () => ImageStorageController(),
);

class ImageStorageController extends Notifier<bool> {
  @override
  build() {
    return false;
  }

  Future<void> uploadImageToStorage(
      {required imageFile,
      required BuildContext context,
      required String folderName,
      required String fileName}) async {
    state = true;

    final res = await ref
        .read(imageStorageRepositoryProvider)
        .uploadImageToStorage(
            imageFile: imageFile, fileName: fileName, folderName: folderName);
    state = false;
    res.fold(
        (l) => showSnackBar(
            content: l.errMSg,
            context: context,
            color: Palette.snackBarErrorColor), (url) async {
      return ref.read(imageUrlProvider.notifier).update((state) => url);
    });
  }
}

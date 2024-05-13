import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';

import '../../error_handling/failure.dart';
import '../../error_handling/type_defs.dart';

final imageStorageRepositoryProvider = Provider<ImageStorageRepository>((ref) {
  return ImageStorageRepository();
});

class ImageStorageRepository {
  FutureEither<String> uploadImageToStorage(
      {required XFile imageFile,
      required String fileName,
      required String folderName}) async {
    try {
      File file = File(imageFile.path);
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('$folderName/${DateTime.now().millisecondsSinceEpoch}');
      final UploadTask uploadTask = storageReference.putFile(file);
      final TaskSnapshot storageSnapshot =
          await uploadTask.whenComplete(() => null);
      final String downloadUrl = await storageSnapshot.ref.getDownloadURL();
      return right(downloadUrl);
    } catch (e) {
      return left(
        Failure(
          errMSg: e.toString(),
        ),
      );
    }
  }
}

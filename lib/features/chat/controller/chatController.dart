import 'dart:convert';

import 'package:chat_app/core/imageStorage/controller/imageStorageController.dart';
import 'package:chat_app/core/theme/theme.dart';
import 'package:chat_app/core/utilities/custom_snackBar.dart';
import 'package:chat_app/features/chat/repository/chatRepository.dart';
import 'package:chat_app/models/chatMessageModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final chatControllerProvider = NotifierProvider<ChatController, bool>(
  () => ChatController(),
);

final getChatStreamProvider =
    StreamProvider.family<List<ChatMessageModel>, String>((ref, params) {
  final decodedParams = jsonDecode(params);
  return ref.read(chatControllerProvider.notifier).getChatStream(
        userPhoneNo: decodedParams["userPhoneNo"],
        limit: decodedParams["limit"],
      );
});

final getChatTileStream =
    StreamProvider.family<List<Map<String, dynamic>>, String>((ref, params) {
  final decodedParams = jsonDecode(params);
  return ref.read(chatControllerProvider.notifier).getChatTileStream();
});

final getChatTileCountStreamProvider =
    StreamProvider.family<int, String>((ref, params) {
  final decodedParams = jsonDecode(params);
  return ref
      .read(chatControllerProvider.notifier)
      .getChatTileCount(userPhoneNo: params);
});

class ChatController extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  Future<void> sendMessage(
      {required BuildContext context,
      required ChatMessageModel chatMessageModel,
      required XFile? attachment}) async {
    ChatMessageModel currentChatMessage = chatMessageModel;

    if (attachment != null) {
      state = true;
      await ref.read(imageStorageController.notifier).uploadImageToStorage(
            imageFile: attachment,
            context: context,
            folderName: "ChatImages",
            fileName:
                "${chatMessageModel.userPhone}-${DateTime.now().microsecondsSinceEpoch}",
          );

      currentChatMessage = currentChatMessage.copyWith(
        imageMessage: ref.read(imageUrlProvider),
      );

      ref.read(imageUrlProvider.notifier).state = null;
    }

    final res = await ref
        .read(chatRepositoryProvider)
        .sendMessage(chatMessageModel: currentChatMessage);

    state = false;
    res.fold(
      (l) => showSnackBar(
          content: l.errMSg,
          context: context,
          color: Palette.snackBarErrorColor),
      (r) => null,
    );
  }

  Future<void> markAsRead(
      {required BuildContext context,
      required ChatMessageModel chatMessageModel}) async {
    final res = await ref
        .read(adminChatRepositoryProvider)
        .markAsRead(chatMessageModel: chatMessageModel);
    res.fold((l) => null, (r) => null);
  }

  Stream<List<ChatMessageModel>> getChatStream(
      {required String userPhoneNo, required int limit}) {
    return ref
        .read(chatRepositoryProvider)
        .getChatStream(userPhoneNo: userPhoneNo, limit: limit);
  }

  Stream<List<Map<String, dynamic>>> getChatTileStream() {
    return ref.read(chatRepositoryProvider).getChatTileStream();
  }

  Stream<int> getChatTileCount({required String userPhoneNo}) {
    return ref
        .read(chatRepositoryProvider)
        .getChatTileCount(userPhoneNo: userPhoneNo);
  }
}

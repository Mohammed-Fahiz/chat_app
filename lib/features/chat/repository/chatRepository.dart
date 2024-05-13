import 'package:chat_app/core/error_handling/failure.dart';
import 'package:chat_app/core/error_handling/type_defs.dart';
import 'package:chat_app/models/chatMessageModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository();
});

final adminChatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository();
});

class ChatRepository {
  FutureVoid sendMessage({
    required ChatMessageModel chatMessageModel,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection("chats")
          .doc(chatMessageModel.receiver)
          .update({"adminFcmToken": chatMessageModel.fcmToken}).then(
              (value) async {
        await FirebaseFirestore.instance
            .collection("chats")
            .doc(chatMessageModel.receiver)
            .collection("messages")
            .add(chatMessageModel.toMap())
            .then((value) async {
          await value.update({"id": value.id});
        });
      });

      return right(null);
    } catch (e) {
      return left(Failure(errMSg: e.toString()));
    }
  }

  FutureVoid markAsRead({
    required ChatMessageModel chatMessageModel,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection("chats")
          .doc(chatMessageModel.sender)
          .collection("messages")
          .doc(chatMessageModel.id)
          .update({"isRead": true});

      return right(null);
    } catch (e) {
      print(e);
      return left(Failure(errMSg: e.toString()));
    }
  }

  Stream<List<ChatMessageModel>> getChatStream(
      {required String userPhoneNo, required int limit}) {
    DateTime sevenDaysAgo = DateTime.now().subtract(Duration(days: limit));
    return FirebaseFirestore.instance
        .collection("chats")
        .doc(userPhoneNo)
        .collection("messages")
        .where("sendTime", isGreaterThan: sevenDaysAgo)
        .orderBy("sendTime", descending: true)
        .snapshots()
        .map((event) {
      return event.docs.map((e) => ChatMessageModel.fromMap(e.data())).toList();
    });
  }

  Stream<List<Map<String, dynamic>>> getChatTileStream() {
    return FirebaseFirestore.instance
        .collection("chats")
        .where("userType", isEqualTo: "admin")
        .orderBy("sendTime", descending: true)
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }

  Stream<int> getChatTileCount({required String userPhoneNo}) {
    return FirebaseFirestore.instance
        .collection("chats")
        .doc(userPhoneNo)
        .collection("messages")
        .where("sender", isEqualTo: userPhoneNo)
        .where("isRead", isEqualTo: false)
        .snapshots()
        .map((event) => event.size);
  }
}

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
          .doc(chatMessageModel.chatDocId)
          .set({
        "docId": chatMessageModel.chatDocId,
        "sendTime": FieldValue.serverTimestamp(),
        "senderName": chatMessageModel.senderName,
        "senderId": chatMessageModel.senderId,
        "receiverId": chatMessageModel.receiver,
        "senderPhone": chatMessageModel.senderPhone,
        "senderImage": chatMessageModel.senderImage,
        "receiverName": chatMessageModel.receiverName,
        "receiverImage": chatMessageModel.receiverImage,
        "receiverPhone": chatMessageModel.receiverPhone
      }).then((value) async {
        await FirebaseFirestore.instance
            .collection("chats")
            .doc(chatMessageModel.chatDocId)
            .collection("messages")
            .add(chatMessageModel.toMap())
            .then((value) async {
          await value.update({"msgId": value.id});
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
          .doc(chatMessageModel.chatDocId)
          .collection("messages")
          .doc(chatMessageModel.msgId)
          .update({"isRead": true});

      return right(null);
    } catch (e) {
      return left(Failure(errMSg: e.toString()));
    }
  }

  Stream<List<ChatMessageModel>> getChatStream(
      {required String chatDocId, required int limit}) {
    print(chatDocId);
    print("CHAT DOC CHAT STREAM");
    DateTime sevenDaysAgo = DateTime.now().subtract(Duration(days: limit));
    return FirebaseFirestore.instance
        .collection("chats")
        .doc(chatDocId)
        .collection("messages")
        .where("sendTime", isGreaterThan: sevenDaysAgo)
        .orderBy("sendTime", descending: true)
        .snapshots()
        .map((event) {
      return event.docs.map((e) => ChatMessageModel.fromMap(e.data())).toList();
    });
  }

  Stream<List<Map<String, dynamic>>> getChatTileStream(
      {required String userId}) {
    return FirebaseFirestore.instance
        .collection("chats")
        .where(
          Filter.or(
            Filter('senderId', isEqualTo: userId),
            Filter('receiverId', isEqualTo: userId),
          ),
        )
        .orderBy("sendTime", descending: true)
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  final String? msgId;
  final String chatDocId;
  final String senderId;

  final String senderName;
  final String receiverName;
  final String receiverPhone;
  final String receiverImage;
  final String senderPhone;
  final String senderImage;
  final String messageType;
  final String textMessage;
  final String imageMessage;
  final bool isRead;
  final Timestamp sendTime;

  final String sender;
  final String receiver;

  final String fcmToken;

//<editor-fold desc="Data Methods">
  const ChatMessageModel({
    this.msgId,
    required this.chatDocId,
    required this.senderId,
    required this.senderName,
    required this.receiverName,
    required this.receiverPhone,
    required this.receiverImage,
    required this.senderPhone,
    required this.senderImage,
    required this.messageType,
    required this.textMessage,
    required this.imageMessage,
    required this.isRead,
    required this.sendTime,
    required this.sender,
    required this.receiver,
    required this.fcmToken,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatMessageModel &&
          runtimeType == other.runtimeType &&
          msgId == other.msgId &&
          chatDocId == other.chatDocId &&
          senderId == other.senderId &&
          senderName == other.senderName &&
          receiverName == other.receiverName &&
          receiverPhone == other.receiverPhone &&
          receiverImage == other.receiverImage &&
          senderPhone == other.senderPhone &&
          senderImage == other.senderImage &&
          messageType == other.messageType &&
          textMessage == other.textMessage &&
          imageMessage == other.imageMessage &&
          isRead == other.isRead &&
          sendTime == other.sendTime &&
          sender == other.sender &&
          receiver == other.receiver &&
          fcmToken == other.fcmToken);

  @override
  int get hashCode =>
      msgId.hashCode ^
      chatDocId.hashCode ^
      senderId.hashCode ^
      senderName.hashCode ^
      receiverName.hashCode ^
      receiverPhone.hashCode ^
      receiverImage.hashCode ^
      senderPhone.hashCode ^
      senderImage.hashCode ^
      messageType.hashCode ^
      textMessage.hashCode ^
      imageMessage.hashCode ^
      isRead.hashCode ^
      sendTime.hashCode ^
      sender.hashCode ^
      receiver.hashCode ^
      fcmToken.hashCode;

  @override
  String toString() {
    return 'ChatMessageModel{' +
        ' msgId: $msgId,' +
        ' chatDocId: $chatDocId,' +
        ' senderId: $senderId,' +
        ' senderName: $senderName,' +
        ' receiverName: $receiverName,' +
        ' receiverPhone: $receiverPhone,' +
        ' receiverImage: $receiverImage,' +
        ' senderPhone: $senderPhone,' +
        ' senderImage: $senderImage,' +
        ' messageType: $messageType,' +
        ' textMessage: $textMessage,' +
        ' imageMessage: $imageMessage,' +
        ' isRead: $isRead,' +
        ' sendTime: $sendTime,' +
        ' sender: $sender,' +
        ' receiver: $receiver,' +
        ' fcmToken: $fcmToken,' +
        '}';
  }

  ChatMessageModel copyWith({
    String? msgId,
    String? chatDocId,
    String? senderId,
    String? senderName,
    String? receiverName,
    String? receiverPhone,
    String? receiverImage,
    String? senderPhone,
    String? senderImage,
    String? messageType,
    String? textMessage,
    String? imageMessage,
    bool? isRead,
    Timestamp? sendTime,
    String? sender,
    String? receiver,
    String? fcmToken,
  }) {
    return ChatMessageModel(
      msgId: msgId ?? this.msgId,
      chatDocId: chatDocId ?? this.chatDocId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      receiverName: receiverName ?? this.receiverName,
      receiverPhone: receiverPhone ?? this.receiverPhone,
      receiverImage: receiverImage ?? this.receiverImage,
      senderPhone: senderPhone ?? this.senderPhone,
      senderImage: senderImage ?? this.senderImage,
      messageType: messageType ?? this.messageType,
      textMessage: textMessage ?? this.textMessage,
      imageMessage: imageMessage ?? this.imageMessage,
      isRead: isRead ?? this.isRead,
      sendTime: sendTime ?? this.sendTime,
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'msgId': this.msgId,
      'chatDocId': this.chatDocId,
      'senderId': this.senderId,
      'senderName': this.senderName,
      'receiverName': this.receiverName,
      'receiverPhone': this.receiverPhone,
      'receiverImage': this.receiverImage,
      'senderPhone': this.senderPhone,
      'senderImage': this.senderImage,
      'messageType': this.messageType,
      'textMessage': this.textMessage,
      'imageMessage': this.imageMessage,
      'isRead': this.isRead,
      'sendTime': this.sendTime,
      'sender': this.sender,
      'receiver': this.receiver,
      'fcmToken': this.fcmToken,
    };
  }

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
    return ChatMessageModel(
      msgId: map['msgId'] as String,
      chatDocId: map['chatDocId'] as String,
      senderId: map['senderId'] as String,
      senderName: map['senderName'] as String,
      receiverName: map['receiverName'] as String,
      receiverPhone: map['receiverPhone'] as String,
      receiverImage: map['receiverImage'] as String,
      senderPhone: map['senderPhone'] as String,
      senderImage: map['senderImage'] as String,
      messageType: map['messageType'] as String,
      textMessage: map['textMessage'] as String,
      imageMessage: map['imageMessage'] as String,
      isRead: map['isRead'] as bool,
      sendTime: map['sendTime'] as Timestamp,
      sender: map['sender'] as String,
      receiver: map['receiver'] as String,
      fcmToken: map['fcmToken'] as String,
    );
  }

//</editor-fold>
}

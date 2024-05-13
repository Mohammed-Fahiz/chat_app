import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  final String? id;
  final String userId;
  final String userName;
  final String userPhone;
  final String userImage;
  final String messageType;
  final String textMessage;
  final String imageMessage;
  final bool isRead;
  final Timestamp sendTime;
  final String topic;
  final String orderNo;
  final String orderDetailNo;
  final String designCode;
  final String designCodeId;
  final String sender;
  final String receiver;
  final String userType;
  final String fcmToken;

//<editor-fold desc="Data Methods">
  const ChatMessageModel({
    this.id,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.userImage,
    required this.messageType,
    required this.textMessage,
    required this.imageMessage,
    required this.isRead,
    required this.sendTime,
    required this.topic,
    required this.orderNo,
    required this.orderDetailNo,
    required this.designCode,
    required this.designCodeId,
    required this.sender,
    required this.receiver,
    required this.userType,
    required this.fcmToken,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatMessageModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          userName == other.userName &&
          userPhone == other.userPhone &&
          userImage == other.userImage &&
          messageType == other.messageType &&
          textMessage == other.textMessage &&
          imageMessage == other.imageMessage &&
          isRead == other.isRead &&
          sendTime == other.sendTime &&
          topic == other.topic &&
          orderNo == other.orderNo &&
          orderDetailNo == other.orderDetailNo &&
          designCode == other.designCode &&
          designCodeId == other.designCodeId &&
          sender == other.sender &&
          receiver == other.receiver &&
          userType == other.userType &&
          fcmToken == other.fcmToken);

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      userName.hashCode ^
      userPhone.hashCode ^
      userImage.hashCode ^
      messageType.hashCode ^
      textMessage.hashCode ^
      imageMessage.hashCode ^
      isRead.hashCode ^
      sendTime.hashCode ^
      topic.hashCode ^
      orderNo.hashCode ^
      orderDetailNo.hashCode ^
      designCode.hashCode ^
      designCodeId.hashCode ^
      sender.hashCode ^
      receiver.hashCode ^
      userType.hashCode ^
      fcmToken.hashCode;

  @override
  String toString() {
    return 'ChatMessageModel{' +
        ' id: $id,' +
        ' userId: $userId,' +
        ' userName: $userName,' +
        ' userPhone: $userPhone,' +
        ' userImage: $userImage,' +
        ' messageType: $messageType,' +
        ' textMessage: $textMessage,' +
        ' imageMessage: $imageMessage,' +
        ' isRead: $isRead,' +
        ' sendTime: $sendTime,' +
        ' topic: $topic,' +
        ' orderNo: $orderNo,' +
        ' orderDetailNo: $orderDetailNo,' +
        ' designCode: $designCode,' +
        ' designCodeId: $designCodeId,' +
        ' sender: $sender,' +
        ' receiver: $receiver,' +
        ' userType: $userType,' +
        ' fcmToken: $fcmToken,' +
        '}';
  }

  ChatMessageModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userPhone,
    String? userImage,
    String? messageType,
    String? textMessage,
    String? imageMessage,
    bool? isRead,
    Timestamp? sendTime,
    String? topic,
    String? orderNo,
    String? orderDetailNo,
    String? designCode,
    String? designCodeId,
    String? sender,
    String? receiver,
    String? userType,
    String? fcmToken,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPhone: userPhone ?? this.userPhone,
      userImage: userImage ?? this.userImage,
      messageType: messageType ?? this.messageType,
      textMessage: textMessage ?? this.textMessage,
      imageMessage: imageMessage ?? this.imageMessage,
      isRead: isRead ?? this.isRead,
      sendTime: sendTime ?? this.sendTime,
      topic: topic ?? this.topic,
      orderNo: orderNo ?? this.orderNo,
      orderDetailNo: orderDetailNo ?? this.orderDetailNo,
      designCode: designCode ?? this.designCode,
      designCodeId: designCodeId ?? this.designCodeId,
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
      userType: userType ?? this.userType,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'userId': this.userId,
      'userName': this.userName,
      'userPhone': this.userPhone,
      'userImage': this.userImage,
      'messageType': this.messageType,
      'textMessage': this.textMessage,
      'imageMessage': this.imageMessage,
      'isRead': this.isRead,
      'sendTime': this.sendTime,
      'topic': this.topic,
      'orderNo': this.orderNo,
      'orderDetailNo': this.orderDetailNo,
      'designCode': this.designCode,
      'designCodeId': this.designCodeId,
      'sender': this.sender,
      'receiver': this.receiver,
      'userType': this.userType,
      'fcmToken': this.fcmToken,
    };
  }

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
    return ChatMessageModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      userName: map['userName'] as String,
      userPhone: map['userPhone'] as String,
      userImage: map['userImage'] ?? "",
      messageType: map['messageType'] as String,
      textMessage: map['textMessage'] as String,
      imageMessage: map['imageMessage'] as String,
      isRead: map['isRead'] as bool,
      sendTime: map['sendTime'] as Timestamp,
      topic: map['topic'] as String,
      orderNo: map['orderNo'] as String,
      orderDetailNo: map['orderDetailNo'] as String,
      designCode: map['designCode'] as String,
      designCodeId: map['designCodeId'] as String,
      sender: map['sender'] as String,
      receiver: map['receiver'] as String,
      userType: map['userType'] as String,
      fcmToken: map['fcmToken'] ?? "",
    );
  }

//</editor-fold>
}

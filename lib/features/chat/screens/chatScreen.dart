import 'dart:convert';

import 'package:chat_app/core/error_handling/error_text.dart';
import 'package:chat_app/core/utilities/loader.dart';
import 'package:chat_app/features/auth/controller/auth_controller.dart';
import 'package:chat_app/features/chat/common/chatCommonFunctions.dart';
import 'package:chat_app/features/chat/controller/chatController.dart';
import 'package:chat_app/features/chat/widgets/audioCard.dart';
import 'package:chat_app/features/chat/widgets/messageInputWidget.dart';
import 'package:chat_app/features/chat/widgets/replyCard.dart';
import 'package:chat_app/features/chat/widgets/replyImage.dart';
import 'package:chat_app/features/chat/widgets/sendImageWidget.dart';
import 'package:chat_app/features/chat/widgets/sendMessage.dart';
import 'package:chat_app/models/chatMessageModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/theme/theme.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String chatUserId;
  final String chatUserName;
  final String chatUserImage;
  final String chatUserPhone;

  const ChatScreen(
      {super.key,
      required this.chatUserId,
      required this.chatUserName,
      required this.chatUserImage,
      required this.chatUserPhone});

  @override
  ConsumerState<ChatScreen> createState() => _SmithChatScreenState();
}

class _SmithChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final attachmentProvider = StateProvider<XFile?>((ref) => null);
  final chatLimitProvider = StateProvider<int>((ref) => 7);
  late String senderId;
  late String receiverId;

  @override
  void initState() {
    senderId = ref.read(userProvider)!.userId!;
    receiverId = widget.chatUserId;
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    final isLoading = ref.watch(chatControllerProvider);
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      appBar: AppBar(
        backgroundColor: Palette.backgroundColor,
        centerTitle: false,
        elevation: 0,
        title: Text(
          widget.chatUserName,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: 'Urbanist',
              fontSize: w * 0.039,
              color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () async => await paginateChat(),
            icon: const Icon(
              Icons.more_vert,
            ),
          )
        ],
      ),
      body: !isLoading
          ? Column(
              children: <Widget>[
                Expanded(child: Consumer(
                  builder: (context, ref, child) {
                    final limit = ref.watch(chatLimitProvider);
                    Map paramMap = {
                      "limit": limit,
                      "chatDocId": ChatCommonFunctions.getChatDocId(
                        senderId: senderId,
                        receiverId: receiverId,
                      ),
                    };

                    return ref
                        .watch(getChatStreamProvider(jsonEncode(paramMap)))
                        .when(
                          data: (chatList) {
                            return ListView.builder(
                              itemCount: chatList.length,
                              reverse: true,
                              itemBuilder: (context, index) {
                                final message = chatList[index];

                                markAsRead(chatMessageModel: message);

                                return _buildMessage(
                                    message: message, w: w, h: h);
                              },
                            );
                          },
                          error: (error, stackTrace) {
                            return ErrorText(
                              errorText: error.toString(),
                            );
                          },
                          loading: () => const Loader(),
                        );
                  },
                )),
                MessageInputWidget(
                  sendMessage: () async => await sendMessage(),
                  attachment: () async => await pickAttachment(),
                  textEditingController: _textController,
                ),
              ],
            )
          : const Loader(),
    );
  }

  Widget _buildMessage(
      {required ChatMessageModel message,
      required double h,
      required double w}) {
    String messageType = message.messageType;
    final user = ref.read(userProvider)!;

    if (messageType == 'textMessage') {
      if (message.senderId == senderId) {
        return SendMessageCard(message: message);
      } else {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ReplyCard(message: message),
          ],
        );
      }
    } else if (messageType == "imageMessage") {
      if (message.senderId == senderId) {
        return SendImageWidget(message: message);
      } else {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ReplyImageWidget(message: message),
          ],
        );
      }
    } else if (messageType == "audioMessage") {
      return AudioMessage(
        message: message,
        isSender: message.senderId == senderId ? true : false,
      );
    }
    return Container();
  }

  Future<void> pickAttachment() async {
    await ChatCommonFunctions.sendAttachment(context: context)
        .then((value) async {
      ref.read(attachmentProvider.notifier).state = value;
    }).then((value) async {
      final pickedImage = ref.read(attachmentProvider);
      if (pickedImage != null) {
        await ChatCommonFunctions.showImageBeforeSend(
          pickedImage: pickedImage,
          sendImage: () async => await sendMessage(),
          cancelImage: () => cancelImage(),
          context: context,
        ).then((value) => cancelImage());
      }
    });
  }

  cancelImage() {
    ref.read(attachmentProvider.notifier).state = null;
  }

  Future<void> sendMessage() async {
    final text = _textController.text.trim();

    _textController.clear();
    final attachment = ref.read(attachmentProvider);
    final user = ref.read(userProvider)!;

    ChatMessageModel? finalMessageModel;

    ChatMessageModel chatMessageModel = ChatMessageModel(
      msgId: "",
      chatDocId: ChatCommonFunctions.getChatDocId(
        senderId: senderId,
        receiverId: receiverId,
      ),
      receiverName: widget.chatUserName,
      receiverImage: widget.chatUserImage,
      receiverPhone: widget.chatUserPhone,
      senderId: senderId,
      senderName: user.name,
      senderPhone: user.userPhoneNo,
      messageType: "",
      textMessage: "",
      imageMessage: "",
      isRead: false,
      sendTime: Timestamp.now(),
      sender: senderId,
      senderImage: user.userImage ?? "",
      receiver: receiverId,
      fcmToken: ref.read(fcmTokenProvider).toString(),
    );

    if (attachment != null) {
      finalMessageModel = chatMessageModel.copyWith(
        textMessage: text.trim(),
        messageType: "imageMessage",
      );
    } else if (text.isNotEmpty) {
      finalMessageModel = chatMessageModel.copyWith(
        textMessage: text.trim(),
        messageType: "textMessage",
      );
    }

    if (finalMessageModel != null) {
      await ref
          .read(chatControllerProvider.notifier)
          .sendMessage(
            context: context,
            chatMessageModel: finalMessageModel,
            attachment: attachment,
          )
          .then((value) {
        ref.read(attachmentProvider.notifier).state = null;
      });
    }
  }

  paginateChat() async {
    await ChatCommonFunctions.messagePaginationDialog(
      context: context,
      content: "Show chat from",
      pos: "Apply",
      currentLimit: ref.read(chatLimitProvider),
    ).then((value) {
      ref.read(chatLimitProvider.notifier).state = value ?? 7;
      final limit = ref.read(chatLimitProvider);
      Map paramMap = {
        "limit": limit,
        "chatDocId": ChatCommonFunctions.getChatDocId(
          senderId: senderId,
          receiverId: receiverId,
        ),
      };

      ref.refresh(getChatStreamProvider(jsonEncode(paramMap)));
    });
  }

  Future<void> markAsRead({required ChatMessageModel chatMessageModel}) async {
    final user = ref.read(userProvider)!;
    if (chatMessageModel.isRead == false &&
        chatMessageModel.sender != user.userPhoneNo) {
      await ref
          .read(chatControllerProvider.notifier)
          .markAsRead(context: context, chatMessageModel: chatMessageModel);
    }
  }
}

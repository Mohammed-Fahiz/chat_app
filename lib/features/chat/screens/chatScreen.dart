import 'dart:convert';

import 'package:chat_app/core/error_handling/error_text.dart';
import 'package:chat_app/core/utilities/loader.dart';
import 'package:chat_app/features/auth/controller/auth_controller.dart';
import 'package:chat_app/features/chat/common/chatCommonFunctions.dart';
import 'package:chat_app/features/chat/controller/chatController.dart';
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
  final String chatPhoneNumber;
  final String chatUserType;
  final String chatUserName;

  const ChatScreen({
    Key? key,
    required this.chatPhoneNumber,
    required this.chatUserType,
    required this.chatUserName,
  }) : super(key: key);

  @override
  ConsumerState<ChatScreen> createState() => _SmithChatScreenState();
}

class _SmithChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final attachmentProvider = StateProvider<XFile?>((ref) => null);
  final chatLimitProvider = StateProvider<int>((ref) => 7);

  @override
  void initState() {
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
          "${widget.chatUserType} : ${widget.chatUserName}",
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
                      "phoneNo": widget.chatPhoneNumber,
                    };

                    return ref
                        .watch(getChatStreamProvider(jsonEncode(paramMap)))
                        .when(
                          data: (chatList) {
                            String previousTopic = "";
                            return ListView.builder(
                              itemCount: chatList.length,
                              reverse: true,
                              itemBuilder: (context, index) {
                                final message = chatList[index];
                                String topic = "";

                                if (previousTopic != message.topic) {
                                  topic = message.topic;

                                  previousTopic = message.topic;
                                }
                                markAsRead(chatMessageModel: message);

                                return _buildMessage(
                                    message: message, topic: topic, w: w, h: h);
                              },
                            );
                          },
                          error: (error, stackTrace) => ErrorText(
                            errorText: error.toString(),
                          ),
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
      required String topic,
      required double h,
      required double w}) {
    String messageType = message.messageType;
    final user = ref.read(userProvider)!;

    if (messageType == 'textMessage') {
      if (message.sender == user.userPhoneNo) {
        return SendMessageCard(message: message);
      } else {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (topic != "")
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(w * 0.02),
                  color: Palette.primaryColor,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: w * 0.03, vertical: h * 0.005),
                  child: Text(
                    topic,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Urbanist',
                        fontSize: w * 0.031,
                        color: Colors.white),
                  ),
                ),
              ),
            ReplyCard(message: message),
          ],
        );
      }
    } else if (messageType == "imageMessage") {
      if (message.sender == user.userPhoneNo) {
        return SendImageWidget(message: message);
      } else {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (topic != "")
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(w * 0.02),
                  color: Palette.primaryColor,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: w * 0.03,
                    vertical: h * 0.005,
                  ),
                  child: Text(
                    topic,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Urbanist',
                        fontSize: w * 0.031,
                        color: Colors.white),
                  ),
                ),
              ),
            ReplyImageWidget(message: message),
          ],
        );
      }
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
      //TO WHO
      id: "",
      userId: user.userPhoneNo,
      userName: user.name,
      userPhone: user.userPhoneNo,
      messageType: "",
      textMessage: "",
      imageMessage: "",
      isRead: false,
      sendTime: Timestamp.now(),
      topic: "",
      orderNo: "",
      orderDetailNo: "",
      designCodeId: "",
      designCode: "",
      sender: user.userPhoneNo,
      userImage: user.userImage ?? "",
      receiver: widget.chatPhoneNumber,
      userType: widget.chatUserType,
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
        "phoneNo": widget.chatPhoneNumber,
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

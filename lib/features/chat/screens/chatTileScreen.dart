import 'dart:convert';

import 'package:chat_app/core/app_constants/app_constants.dart';
import 'package:chat_app/core/error_handling/error_text.dart';
import 'package:chat_app/core/formatDate/convertDate.dart';
import 'package:chat_app/core/navigation_service.dart';
import 'package:chat_app/core/theme/theme.dart';
import 'package:chat_app/core/utilities/customDialogBox.dart';
import 'package:chat_app/core/utilities/loader.dart';
import 'package:chat_app/features/auth/controller/auth_controller.dart';
import 'package:chat_app/features/chat/common/chatCommonFunctions.dart';
import 'package:chat_app/features/chat/controller/chatController.dart';
import 'package:chat_app/features/chat/screens/chatScreen.dart';
import 'package:chat_app/features/users/screens/user_list_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatTileScreen extends ConsumerStatefulWidget {
  const ChatTileScreen({super.key});

  @override
  ConsumerState createState() => _ChatTileScreenAdminState();
}

class _ChatTileScreenAdminState extends ConsumerState<ChatTileScreen> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat',
          style: TextStyle(
              fontFamily: 'Urbanist',
              color: Colors.black,
              fontSize: w * 0.07,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () async => await logOut(),
            icon: const Icon(Icons.settings),
          ),
          IconButton(
            onPressed: () async => NavigationService.navigateToScreen(
              context: context,
              screen: const UsersListScreen(),
            ),
            icon: const Icon(Icons.supervised_user_circle_sharp),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final user = ref.watch(userProvider)!;
                final userId = user.userId!;
                return ref.watch(getChatTileStream(userId)).when(
                      data: (chatTileList) {
                        if (chatTileList.isNotEmpty) {
                          return ListView.builder(
                            itemCount: chatTileList.length,
                            itemBuilder: (context, index) {
                              final chatTile = chatTileList[index];

                              return GestureDetector(
                                onTap: () {
                                  final userId =
                                      ref.read(userProvider)!.userId!;

                                  NavigationService.navigateToScreen(
                                    context: context,
                                    screen: ChatScreen(
                                      chatUserId:
                                          chatTile["receiverId"] == userId
                                              ? chatTile["senderId"]
                                              : chatTile["receiverId"],
                                      chatUserName:
                                          chatTile["receiverId"] == userId
                                              ? chatTile["senderName"]
                                              : chatTile["receiverName"],
                                      chatUserImage:
                                          chatTile["receiverId"] == userId
                                              ? chatTile["senderImage"]
                                              : chatTile["receiverImage"],
                                      chatUserPhone:
                                          chatTile["receiverId"] == userId
                                              ? chatTile["senderPhone"]
                                              : chatTile["receiverPhone"],
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 1.0),
                                  child: Container(
                                    height: h * .1,
                                    width: w,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(width: w * 0.03),
                                        CircleAvatar(
                                          radius: h * 0.03,
                                          foregroundImage: NetworkImage(
                                            chatTile["receiverId"] == userId
                                                ? chatTile["senderImage"]
                                                : chatTile["receiverImage"],
                                          ),
                                        ),
                                        SizedBox(width: w * 0.03),
                                        Container(
                                          width: w * 0.6,
                                          color: Colors.white,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                chatTile["receiverId"] == userId
                                                    ? chatTile["senderName"]
                                                    : chatTile["receiverName"],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: w * 0.042,
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                chatTile["receiverId"] == userId
                                                    ? chatTile["senderPhone"]
                                                    : chatTile["receiverPhone"],
                                                style: TextStyle(
                                                    fontSize: w * 0.04,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          ConvertDateTime
                                              .convertTimeStampToReadableNoDate(
                                            timestamp: chatTile['sendTime'] ??
                                                Timestamp.now(),
                                          ),
                                          style: TextStyle(
                                              fontSize: w * 0.024,
                                              color: Colors.black),
                                        ),
                                        SizedBox(width: w * 0.03)
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return Center(
                            child: GestureDetector(
                              onTap: () {
                                NavigationService.navigateToScreen(
                                  context: context,
                                  screen: const UsersListScreen(),
                                );
                              },
                              child: Container(
                                height: h * .05,
                                width: w * .9,
                                decoration: BoxDecoration(
                                  color: Palette.primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    "Start chat with some one",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Urbanist',
                                      fontSize: w * 0.039,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      error: (error, stackTrace) {
                        return ErrorText(
                          errorText: error.toString(),
                        );
                      },
                      loading: () => const Loader(),
                    );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> logOut() async {
    await showCustomAlertDialog(
            context: context, content: "Do you want to logOut?", pos: "Yes")
        .then((value) async {
      if (value != null && value == true) {
        await ref
            .read(authControllerProvider.notifier)
            .logOut(context: context);
      }
    });
  }
}

import 'package:chat_app/core/error_handling/error_text.dart';
import 'package:chat_app/core/formatDate/convertDate.dart';
import 'package:chat_app/core/navigation_service.dart';
import 'package:chat_app/core/theme/theme.dart';
import 'package:chat_app/core/utilities/loader.dart';
import 'package:chat_app/features/auth/controller/auth_controller.dart';
import 'package:chat_app/features/chat/controller/chatController.dart';
import 'package:chat_app/features/chat/screens/chatScreen.dart';
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
              color: Colors.white,
              fontSize: w * 0.04,
              fontWeight: FontWeight.bold),
        ), // Example title
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
                                onTap: () => NavigationService.navigateToScreen(
                                  context: context,
                                  screen: ChatScreen(
                                    chatPhoneNumber: chatTile["userPhone"],
                                    chatUserType: chatTile["userType"],
                                    chatUserName: chatTile["userName"],
                                  ),
                                ),
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
                                              chatTile["userImage"] ?? ""),
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
                                                chatTile["userName"],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: w * 0.042,
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                chatTile["userPhone"],
                                                style: TextStyle(
                                                    fontSize: w * 0.04,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            chatCountWidget(
                                              userPhoneNo:
                                                  chatTile["userPhone"],
                                              w: w,
                                              h: h,
                                            ),
                                            SizedBox(height: h * 0.005),
                                            Text(
                                              ConvertDateTime
                                                  .convertTimeStampToReadableNoDate(
                                                timestamp: chatTile['sendTime'],
                                              ),
                                              style: TextStyle(
                                                  fontSize: w * 0.024,
                                                  color: Colors.black),
                                            ),
                                          ],
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
                            child: Text(
                              "Chat list empty",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Urbanist',
                                fontSize: w * 0.039,
                                color: Palette.blackColor,
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

  Consumer chatCountWidget(
      {required String userPhoneNo, required double w, required double h}) {
    return Consumer(
      builder: (context, ref, child) {
        return ref.watch(getChatTileCountStreamProvider(userPhoneNo)).when(
              data: (count) {
                if (count != 0) {
                  return CircleAvatar(
                    radius: w * 0.033,
                    backgroundColor: Palette.primaryColor,
                    child: Text(
                      count.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: w * 0.025,
                          color: Colors.white),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
              error: (error, stackTrace) {
                return const ErrorText(errorText: "");
              },
              loading: () => const SizedBox(),
            );
      },
    );
  }
}

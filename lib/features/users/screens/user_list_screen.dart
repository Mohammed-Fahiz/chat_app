import 'package:chat_app/core/app_constants/app_constants.dart';
import 'package:chat_app/core/error_handling/error_text.dart';
import 'package:chat_app/core/navigation_service.dart';
import 'package:chat_app/core/utilities/loader.dart';
import 'package:chat_app/features/auth/controller/auth_controller.dart';
import 'package:chat_app/features/chat/screens/chatScreen.dart';
import 'package:chat_app/features/users/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UsersListScreen extends ConsumerStatefulWidget {
  const UsersListScreen({super.key});

  @override
  ConsumerState createState() => _UsersListScreenState();
}

class _UsersListScreenState extends ConsumerState<UsersListScreen> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    final user = ref.watch(userProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Users list"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: ref.watch(getAllUsersListProvider(user!.userId!)).when(
                data: (usersList) {
                  if (usersList.isNotEmpty) {
                    return ListView.builder(
                      itemCount: usersList.length,
                      itemBuilder: (context, index) {
                        final user = usersList[index];
                        return SizedBox(
                          height: h * .06,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                user.userImage == null || user.userImage == ""
                                    ? AppConstants.noProfileDefaultImage
                                    : user.userImage!,
                              ),
                            ),
                            title: Text(user.name),
                            subtitle: Text(user.userPhoneNo),
                            trailing: IconButton(
                              onPressed: () {
                                NavigationService.navigateToScreen(
                                  context: context,
                                  screen: ChatScreen(
                                    chatUserName: user.name,
                                    chatUserId: user.userId!,
                                    chatUserPhone: user.userPhoneNo,
                                    chatUserImage: user.userImage ?? "",
                                  ),
                                );
                              },
                              icon: const Icon(Icons.chat),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const ErrorText(
                      errorText: "No Users",
                    );
                  }
                },
                error: (error, stackTrace) => ErrorText(
                  errorText: error.toString(),
                ),
                loading: () => const Loader(),
              ),
        ));
  }
}

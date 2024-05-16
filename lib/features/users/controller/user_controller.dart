import 'package:chat_app/features/users/repository/user_repository.dart';
import 'package:chat_app/models/userModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userControllerProvider = NotifierProvider<UserController, bool>(
  () => UserController(),
);

final getAllUsersListProvider =
    FutureProvider.family<List<UserModel>, String>((ref, userId) async {
  return ref
      .read(userControllerProvider.notifier)
      .getAllUsersList(userId: userId);
});

class UserController extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  Future<List<UserModel>> getAllUsersList({required String userId}) async {
    final res =
        await ref.read(userRepositoryProvider).getAllUsersList(userId: userId);
    return res.fold((l) => throw Exception(l.errMSg), (usersList) => usersList);
  }
}

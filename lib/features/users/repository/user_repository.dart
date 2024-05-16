import 'package:chat_app/core/error_handling/failure.dart';
import 'package:chat_app/core/error_handling/type_defs.dart';
import 'package:chat_app/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

class UserRepository {
  FutureEither<List<UserModel>> getAllUsersList(
      {required String userId}) async {
    try {
      final users = await FirebaseFirestore.instance
          .collection("users")
          .where("userId", isNotEqualTo: userId)
          .get();
      return right(users.docs.map((e) => UserModel.fromMap(e.data())).toList());
    } catch (e) {
      return left(Failure(errMSg: e.toString()));
    }
  }
}

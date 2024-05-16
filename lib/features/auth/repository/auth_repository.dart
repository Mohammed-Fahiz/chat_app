import 'dart:async';

import 'package:chat_app/core/error_handling/failure.dart';
import 'package:chat_app/core/error_handling/type_defs.dart';
import 'package:chat_app/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  FutureEither<UserModel> signUpWithEmailAndPassword(
      {required UserModel userModel, required String password}) async {
    try {
      UserModel updatedUserModel = userModel;
      await _auth
          .createUserWithEmailAndPassword(
        email: userModel.email,
        password: password,
      )
          .then((value) async {
        updatedUserModel = userModel.copyWith(
          userId: value.user!.uid,
        );

        await FirebaseFirestore.instance
            .collection("users")
            .doc(value.user!.uid)
            .set(updatedUserModel.toMap());
      });
      return right(updatedUserModel);
    } catch (e) {
      return left(Failure(errMSg: e.toString()));
    }
  }

  FutureEither<UserModel> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserModel? userModel;
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        final userData = await _firebaseFirestore
            .collection("users")
            .doc(value.user!.uid)
            .get();

        userModel = UserModel.fromMap(userData.data() as Map<String, dynamic>);
      });
      if (userModel != null) {
        return right(userModel!);
      }
      throw "Something went wrong";
    } catch (e) {
      return left(Failure(errMSg: e.toString()));
    }
  }

  FutureVoid addUserImage({required UserModel userModel}) async {
    try {
      await _firebaseFirestore
          .collection("users")
          .doc(userModel.userId)
          .update({"userImage": userModel.userImage ?? "sss"});

      return right(null);
    } catch (e) {
      return left(Failure(errMSg: e.toString()));
    }
  }

  FutureEither<UserModel> getUserData({required String userId}) async {
    try {
      final userData =
          await _firebaseFirestore.collection("users").doc(userId).get();
      if (userData.data() != null) {
        return right(
          UserModel.fromMap(userData.data() as Map<String, dynamic>),
        );
      }

      throw "Something went wrong!";
    } catch (e) {
      return left(Failure(errMSg: e.toString()));
    }
  }

  FutureVoid storeUserDataLocally({required UserModel userModel}) async {
    try {
      await SharedPreferences.getInstance().then((value) {
        value.setString("userId", userModel.userId.toString());
      });
      return right(null);
    } catch (e) {
      return left(Failure(errMSg: e.toString()));
    }
  }

  FutureVoid logOut() async {
    try {
      await SharedPreferences.getInstance().then((prefs) async {
        await prefs.remove("userId");
      });
      return right(null);
    } catch (e) {
      return left(Failure(errMSg: e.toString()));
    }
  }
}

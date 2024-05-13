import 'dart:io';

import 'package:chat_app/core/global_functions.dart';
import 'package:chat_app/core/utilities/customFloatingButton.dart';
import 'package:chat_app/core/utilities/customTextField.dart';
import 'package:chat_app/core/utilities/loader.dart';
import 'package:chat_app/core/validation/email_validation.dart';
import 'package:chat_app/features/auth/controller/auth_controller.dart';
import 'package:chat_app/models/userModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final userNameController = TextEditingController();
  final userNumberController = TextEditingController();
  final userEmailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();
  final pickedImageProvider = StateProvider<XFile?>((ref) => null);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final passObscureProvider = StateProvider<bool>((ref) => true);
  final confirmPassObscureProvider = StateProvider<bool>((ref) => true);
  final isLoadingProvider = StateProvider<bool>((ref) => false);

  @override
  void dispose() {
    super.dispose();
    userNameController.dispose();
    userNumberController.dispose();
    userEmailController.dispose();
    passwordController.dispose();
    confirmPassController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'SIGNUP',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Urbanist',
            fontSize: w * 0.04,
            color: Colors.grey.shade800,
          ),
        ),
      ),
      body: !isLoading
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.03),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: h * 0.03),
                    Consumer(
                      builder: (context, ref, child) {
                        final imageFile = ref.watch(pickedImageProvider);
                        return GestureDetector(
                          onTap: pickImage,
                          child: CircleAvatar(
                            maxRadius: w * .135,
                            backgroundColor: Colors.grey.shade400,
                            child: imageFile != null
                                ? ClipOval(
                                    child: Image.file(
                                      File(imageFile.path),
                                      width: w * .27,
                                      height: w * .27,
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                : Icon(
                                    CupertinoIcons.person_add_solid,
                                    size: w * .15,
                                    color: Colors.black,
                                  ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: userNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "This field can't be empty";
                              } else {
                                return null;
                              }
                            },
                            hintText: 'Full Name',
                            icon: CupertinoIcons.person_alt,
                          ),
                          SizedBox(
                            height: h * .015,
                          ),
                          CustomTextField(
                            controller: userNumberController,
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length != 10) {
                                return "Enter a valid phone number";
                              } else {
                                return null;
                              }
                            },
                            hintText: 'Phone Number',
                            icon: CupertinoIcons.phone,
                          ),
                          SizedBox(
                            height: h * .015,
                          ),
                          CustomTextField(
                            controller: userEmailController,
                            validator: (value) {
                              final isValid = isValidEmail(value ?? "");
                              if (!isValid) {
                                return "Enter a valid email";
                              }
                              return null;
                            },
                            hintText: 'Email',
                            icon: CupertinoIcons.mail,
                          ),
                          SizedBox(
                            height: h * .015,
                          ),
                          Consumer(
                            builder: (context, ref, child) {
                              final isObscure = ref.watch(passObscureProvider);

                              return CustomTextField(
                                controller: passwordController,
                                hintText: 'Password',
                                icon: Icons.password,
                                isObscureText: isObscure,
                                validator: (value) {
                                  if (value != null && value.length < 6) {
                                    return "Enter at least 6 characters";
                                  }
                                  return null;
                                },
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    ref
                                        .read(passObscureProvider.notifier)
                                        .update((state) => !state);
                                  },
                                  child: isObscure
                                      ? const Icon(Icons.remove_red_eye)
                                      : const Icon(
                                          Icons.remove_red_eye_outlined),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            height: h * .015,
                          ),
                          Consumer(
                            builder: (context, ref, child) {
                              final isObscure =
                                  ref.watch(confirmPassObscureProvider);

                              return CustomTextField(
                                controller: confirmPassController,
                                hintText: 'Confirm password',
                                icon: Icons.password,
                                isObscureText: isObscure,
                                validator: (value) {
                                  if (value != null &&
                                      value.trim() !=
                                          passwordController.text.trim()) {
                                    return "Passwords don't match!";
                                  }
                                  return null;
                                },
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    ref
                                        .read(
                                            confirmPassObscureProvider.notifier)
                                        .update((state) => !state);
                                  },
                                  child: isObscure
                                      ? const Icon(Icons.remove_red_eye)
                                      : const Icon(
                                          Icons.remove_red_eye_outlined),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: h * 0.05),
                        ],
                      ),
                    ),
                    SizedBox(height: h * 0.2),
                  ],
                ),
              ),
            )
          : const Loader(),
      floatingActionButton: !isLoading
          ? CustomFloatingButton(
              onTap: () async => await signUp(),
              text: "Signup",
            )
          : const SizedBox(),
    );
  }

  Future<void> pickImage() async {
    final pickedImage =
        await GlobalFunction().showImagePickerModal(context: context);
    if (pickedImage != null) {
      ref.read(pickedImageProvider.notifier).state = pickedImage;
    }
  }

  Future<void> signUp() async {
    if (_formKey.currentState!.validate()) {
      UserModel userModel = UserModel(
        name: userNameController.text.trim(),
        userPhoneNo: userNumberController.text.trim(),
        email: userEmailController.text.trim(),
        userImage: "",
        fcmToken: ref.read(fcmTokenProvider).toString(),
      );

      await ref
          .read(authControllerProvider.notifier)
          .signUpWithEmailAndPassword(
            password: passwordController.text.trim(),
            userModel: userModel,
            context: context,
            imageFile: ref.read(pickedImageProvider),
          );
    }
  }
}

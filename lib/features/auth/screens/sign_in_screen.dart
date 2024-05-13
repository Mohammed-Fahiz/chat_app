import 'package:chat_app/core/theme/theme.dart';
import 'package:chat_app/core/utilities/customTextField.dart';
import 'package:chat_app/core/utilities/custom_snackBar.dart';
import 'package:chat_app/core/utilities/loader.dart';
import 'package:chat_app/core/validation/email_validation.dart';
import 'package:chat_app/features/auth/controller/auth_controller.dart';
import 'package:chat_app/features/auth/screens/sign_up_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState createState() => _PhonePassLoginScreenState();
}

class _PhonePassLoginScreenState extends ConsumerState<SignInScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final isObscureTextProvider = StateProvider<bool>((ref) => true);
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
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
          'LOGIN',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Urbanist',
            fontSize: w * 0.04,
            color: Colors.grey.shade800,
          ),
        ),
      ),
      body: !isLoading
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: h * .02),
                        child: CustomTextField(
                          controller: emailController,
                          validator: (value) {
                            final isValid = isValidEmail(value ?? "");
                            if (!isValid) {
                              return "Enter a valid email";
                            }
                            return null;
                          },
                          hintText: "Enter email",
                        ),
                      ),
                      SizedBox(height: h * .02),
                      Consumer(
                        builder: (context, ref, child) {
                          final isObscure = ref.watch(isObscureTextProvider);
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: h * .02),
                            child: CustomTextField(
                              isObscureText: isObscure,
                              controller: passController,
                              hintText: "Enter password",
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  ref
                                      .read(isObscureTextProvider.notifier)
                                      .update((state) => !state);
                                },
                                child: ref.watch(isObscureTextProvider)
                                    ? const Icon(Icons.remove_red_eye)
                                    : const Icon(Icons.remove_red_eye_outlined),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: h * .02),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: h * .02),
                        child: GestureDetector(
                          onTap: () async => await verifyPhonePass(),
                          child: Container(
                            width: w,
                            height: h * 0.07,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(w * 0.03),
                              color: Palette.primaryColor,
                            ),
                            child: Center(
                              child: Text(
                                "CONTINUE",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Urbanist',
                                    fontSize: w * 0.036,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: h * .02),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const SignupScreen(),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have account? ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Urbanist',
                                fontSize: w * 0.036,
                                color: Palette.blackColor),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Signup',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Urbanist',
                                    fontSize: w * 0.036,
                                    color: Palette.primaryColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: h * .03),
                    ],
                  ),
                ],
              ),
            )
          : const Loader(),
    );
  }

  Future<void> verifyPhonePass() async {
    if (emailController.text.trim().isNotEmpty) {
      if (passController.text.trim().isNotEmpty &&
          passController.text.trim().length >= 6) {
      } else {
        showSnackBar(
            content: "Enter a valid password, at least 6 characters",
            context: context,
            color: Palette.snackBarErrorColor);
      }
    } else {
      showSnackBar(
          content: "Enter a valid email",
          context: context,
          color: Palette.snackBarErrorColor);
    }
  }
}

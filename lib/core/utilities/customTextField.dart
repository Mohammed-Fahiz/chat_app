import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool? readOnly;
  final IconData? icon;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final bool? isObscureText;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField(
      {Key? key,
      required this.hintText,
      this.icon,
      this.onChanged,
      this.validator,
      this.controller,
      this.keyboardType,
      this.readOnly,
      this.suffixIcon,
      this.isObscureText,
      this.inputFormatters,
      this.maxLength})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: TextFormField(
        readOnly: readOnly ?? false,
        controller: controller,
        keyboardType: keyboardType,
        buildCounter: (context,
                {required currentLength,
                required isFocused,
                required maxLength}) =>
            null,
        onChanged: onChanged,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        obscureText: isObscureText ?? false,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          prefixIcon: icon != null ? Icon(icon) : null,
          hintText: hintText,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}

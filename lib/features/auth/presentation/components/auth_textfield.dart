import 'package:flutter/material.dart';

class AuthTextfield extends StatelessWidget {
  final String hintText;
  final Icon textfieldIcon;
  final TextEditingController controller;
  final bool obscureText;
  final String? Function(String?) validator;
  final Widget? suffixIcon;
  const AuthTextfield({
    super.key,
    required this.hintText,
    required this.textfieldIcon,
    required this.controller,
    required this.obscureText,
    required this.validator,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: textfieldIcon,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}

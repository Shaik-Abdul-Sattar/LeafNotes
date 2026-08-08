import 'package:flutter/material.dart';

class NoteTextfield extends StatelessWidget {
  final bool isTitle;
  final String hintText;
  final bool readOnly;
  final TextEditingController controller;
  final FocusNode focusNode;
  const NoteTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.isTitle,
    required this.focusNode,
    required this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: readOnly,
      focusNode: focusNode,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: !isTitle ? TextInputType.multiline : null,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      controller: controller,
      expands: !isTitle,
      maxLines: isTitle ? 1 : null,
      minLines: isTitle ? 1 : null,
      textAlignVertical: TextAlignVertical.top,
      style: TextStyle(
        fontFamily: 'Manrope',
        fontSize: isTitle ? 20 : 16,
        height: !isTitle ? 1.8 : 1,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        hintStyle: TextStyle(
          fontFamily: 'ManRope',
          fontSize: isTitle ? 20 : 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isTitle ? 20 : 12),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: isTitle ? 15 : 10 ,
          vertical: isTitle ? 15 : 10,
        ),
      ),
    );
  }
}

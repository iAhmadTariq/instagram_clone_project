import 'package:flutter/material.dart';
class TextFildInput extends StatelessWidget {
  final bool isPass;
  final String hintText;
  final TextEditingController textEditingController;
  final TextInputType textInputType;
  
  const TextFildInput({
    super.key,
    required this.hintText,
    this.isPass = false,
    required this.textEditingController,
    required this.textInputType,
  });
  
  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context)
    );
    return TextField(
      
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder, 
        filled: true,
        contentPadding: EdgeInsets.all(8),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
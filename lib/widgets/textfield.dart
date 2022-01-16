import 'package:flutter/material.dart';
import 'package:groupstudy/constants/colours.dart';

class ThemeTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType textInputType;
  final int? maxLength;
  late double width;
  late double height;
  late double borderRadius;

  ThemeTextField({ 
    Key? key, 
    this.maxLength, 
    required this.controller, 
    required this.hintText, 
    this.obscureText = false, 
    this.textInputType = TextInputType.text,
    this.width = 250,
    this.height = 50,
    this.borderRadius = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 25,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: TextField(
        keyboardType: textInputType,
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(PRIMARY_COLOR),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: Color(PRIMARY_COLOR),
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: Color(PRIMARY_COLOR),
              width: 1.0,
            ),
          ),
          hintStyle: TextStyle(
            color: Colors.white,
          ),
          hintText: hintText,
        ),
        obscureText: obscureText,
        maxLength: maxLength,
        style: TextStyle(
            color: Colors.white,
        ),
      ),
    );
  }
}
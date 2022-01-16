import 'package:flutter/material.dart';
import 'package:groupstudy/constants/colours.dart';

class ThemeButton extends StatelessWidget {
  final void Function() onTap;
  final String label;
  late double height;
  late double width;

  ThemeButton({ Key? key, required this.onTap, required this.label, this.width = 250, this.height = 50 }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            )
          ),
          backgroundColor: MaterialStateProperty.all<Color>(Color(SECONDARY_COLOR)),
          elevation: MaterialStateProperty.all<double>(10.0),
        ),
        onPressed: onTap,
        child: Text(
          label,
          style: TextStyle(color: Color(PRIMARY_COLOR), fontWeight: FontWeight.bold)
        ),
      ),
    );
  }
}
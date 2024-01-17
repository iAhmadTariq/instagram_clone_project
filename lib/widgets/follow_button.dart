import 'package:flutter/material.dart';
import 'package:instagram_clone_project/utils/colors.dart';

class FollowButton extends StatelessWidget {
  final Function()? onFunction;
  final Color backgroundColor;
  final String text;
  final Color textColor;
  const FollowButton({
    super.key, 
    this.onFunction, 
    required this.backgroundColor,
    required this.text,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        onPressed: onFunction,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
            ),
          ),
          height: 34,
        )
      ),
    );
  }
}
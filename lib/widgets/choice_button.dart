import 'package:flutter/material.dart';

class ChoiceButton extends StatelessWidget {
  final double width;
  final double height;
  final double iconSize;
  final Color iconColor;
  final IconData icon;

  const ChoiceButton({
    super.key,
    required this.width,
    required this.height,
    required this.iconSize,
    required this.iconColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withAlpha(50),
                blurRadius: 4,
                spreadRadius: 4,
                offset: const Offset(3, 3))
          ]),
      child: Icon(
        icon,
        color: iconColor,
        size: iconSize,
      ),
    );
  }
}
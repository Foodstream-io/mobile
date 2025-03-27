// lib/widgets/divider_with_text.dart
import 'package:flutter/material.dart';

class DividerWithText extends StatelessWidget {
  final String text;
  final Color color;

  const DividerWithText({
    super.key,
    required this.text,
    this.color = const Color.fromARGB(255, 1, 1, 63),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: color)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(child: Divider(color: color)),
      ],
    );
  }
}
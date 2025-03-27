// lib/widgets/social_login_button.dart
import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.text,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 30.0,
          ),
          Text(text, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
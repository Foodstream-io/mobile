// lib/widgets/blurred_background.dart
import 'dart:ui';
import 'package:flutter/material.dart';

class BlurredBackground extends StatelessWidget {
  final String imagePath;
  final double sigmaX;
  final double sigmaY;
  final double opacity;

  const BlurredBackground({
    super.key,
    required this.imagePath,
    this.sigmaX = 10,
    this.sigmaY = 10,
    this.opacity = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
            child: Container(
              // Replace withOpacity with withValues to avoid the deprecation warning
              color: Colors.white.withAlpha((opacity * 255).round()),
            ),
          ),
        ),
      ],
    );
  }
}

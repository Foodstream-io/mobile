// lib/utils/snackbar_utils.dart
import 'package:flutter/material.dart';

/// A utility class for displaying snack bars in a Flutter application.
class SnackBarUtils {
  /// Displays a snack bar with the given [message] in the provided [context].
  ///
  /// The snack bar will appear for 2 seconds, have horizontal padding of 20.0,
  /// and will float above other content. It will also have rounded corners
  /// with a radius of 10.0 and a close icon.
  ///
  /// - [Parameters]:
  ///   - context: The BuildContext in which to show the snack bar.
  ///   - message: The message to display in the snack bar.
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        showCloseIcon: true,
        backgroundColor: Colors.orange,
      ),
    );
  }
}

// lib/utils/validation_utils.dart

/// A utility class for validating user input in a Flutter application.
class ValidationUtils {
  /// Determines whether the given [email] is a valid email address.
  static bool isValidEmail(String email) {
    final emailPattern = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailPattern.hasMatch(email);
  }
}

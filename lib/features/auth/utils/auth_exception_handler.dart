import 'package:firebase_auth/firebase_auth.dart';

class AuthExceptionHandler {
  static String getMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return "This email is already registered";

      case 'invalid-email':
        return "Enter a valid email address";

      case 'weak-password':
        return "Password should be at least 6 characters";

      case 'invalid-credential':
        return "Invalid email or password";

      case 'network-request-failed':
        return "Check your internet connection";

      case 'too-many-requests':
        return "Too many attempts. Try again later";
        
      case 'empty-fields':
        return "Fill all fields";

      default:
        return e.code;
    }
  }
}

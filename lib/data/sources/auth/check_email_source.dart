import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckEmailSource {
  /// Checks if the email exists by fetching sign-in methods for the email
  Future<Either<String, String>> checkEmail(String email) async {
    try {
      final firebaseAuth = FirebaseAuth.instance;

      // Fetch sign-in methods associated with the provided email
      final signInMethods =
          await firebaseAuth.fetchSignInMethodsForEmail(email);

      if (signInMethods.isNotEmpty) {
        // Email exists in the system
        return const Left('Email is already registered');
      } else {
        // Email is not registered
        return const Right('Email is available');
      }
    } catch (e) {
      String error = 'Error checking email: $e';
      return Left(error);
    }
  }
}

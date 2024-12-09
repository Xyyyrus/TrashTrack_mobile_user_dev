import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:trashtrack_user/data/repositories/auth_repository.dart';
import 'package:trashtrack_user/models/credential/credential.dart';

class LoginSourceGoogle {
  FESST loginGoogle() async {
    final firebaseAuth = FirebaseAuth.instance;
    final googleSignin = GoogleSignIn();

    try {
      final googleUser = await googleSignin.signIn();
      final googleAuth = await googleUser?.authentication;

      final authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await firebaseAuth.signInWithCredential(authCredential);

      return const Right('Login successful');
    } catch (e) {
      String error = 'Error signing in: $e';

      return Left(error);
    }
  }
}

class LoginSource {
  FESST login(Credential credential) async {
    try {
      final firebaseAuth = FirebaseAuth.instance;

      await firebaseAuth.signInWithEmailAndPassword(
        email: credential.email,
        password: credential.password ?? '',
      );

      return const Right('Login successful');
    } catch (e) {
      String error = 'Error signing in: $e';

      return Left(error);
    }
  }
}



// import 'package:dartz/dartz.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:trashtrack_user/data/repositories/auth_repository.dart';

// typedef FESST = Future<Either<String, String>>;

// class LoginSource {
//   final FirebaseAuth _firebaseAuth;
//   final GoogleSignIn _googleSignIn;

//   LoginSource({
//     FirebaseAuth? firebaseAuth,
//     GoogleSignIn? googleSignIn,
//   })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
//         _googleSignIn = googleSignIn ?? GoogleSignIn();

//   Future<Either<String, String>> login() async {
//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

//       if (googleUser == null) {
//         return const Left('Google Sign In was cancelled');
//       }

//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;

//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       final userCredential =
//           await _firebaseAuth.signInWithCredential(credential);

//       if (userCredential.user == null) {
//         return const Left('Failed to sign in with Google');
//       }

//       return const Right('Login successful');
//     } on FirebaseAuthException catch (e) {
//       return Left(_getFirebaseErrorMessage(e));
//     } on Exception catch (e) {
//       return Left('An unexpected error occurred: ${e.toString()}');
//     }
//   }

//   String _getFirebaseErrorMessage(FirebaseAuthException e) {
//     switch (e.code) {
//       case 'account-exists-with-different-credential':
//         return 'An account already exists with the same email address but different sign-in credentials.';
//       case 'invalid-credential':
//         return 'The credential is malformed or has expired.';
//       case 'operation-not-allowed':
//         return 'Google sign-in is not enabled for this project.';
//       case 'user-disabled':
//         return 'This user account has been disabled.';
//       case 'user-not-found':
//         return 'No user found for that email.';
//       case 'wrong-password':
//         return 'Wrong password provided for that user.';
//       case 'invalid-verification-code':
//         return 'The credential verification code received is invalid.';
//       case 'invalid-verification-id':
//         return 'The credential verification ID received is invalid.';
//       default:
//         return 'An error occurred: ${e.message}';
//     }
//   }
// }
// import 'package:dartz/dartz.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:trashtrack_user/data/repositories/auth_repository.dart';
// import 'package:trashtrack_user/models/credential/credential.dart';

// class LoginSource {
//   FESST login(Credential credential) async {
//     try {
//       final firebaseAuth = FirebaseAuth.instance;

//       await firebaseAuth.signInWithEmailAndPassword(
//         email: credential.email,
//         password: credential.password ?? '',
//       );

//       return const Right('Login successful');
//     } catch (e) {
//       String error = 'Error signing in: $e';

//       return Left(error);
//     }
//   }
// }

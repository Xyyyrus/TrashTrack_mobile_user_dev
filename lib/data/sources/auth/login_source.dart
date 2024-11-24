// import 'package:dartz/dartz.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:trashtrack_user/data/repositories/auth_repository.dart';

// class LoginSource {
//   FESST login() async {
//     final firebaseAuth = FirebaseAuth.instance;
//     final googleSignin = GoogleSignIn();

//     try {
//       final googleUser = await googleSignin.signIn();
//       final googleAuth = await googleUser?.authentication;

//       final authCredential = GoogleAuthProvider.credential(
//         accessToken: googleAuth?.accessToken,
//         idToken: googleAuth?.idToken,
//       );

//       await firebaseAuth.signInWithCredential(authCredential);

//       return const Right('Login successful');
//     } catch (e) {
//       String error = 'Error signing in: $e';

//       return Left(error);
//     }
//   }
// }
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trashtrack_user/data/repositories/auth_repository.dart';
import 'package:trashtrack_user/models/credential/credential.dart';

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

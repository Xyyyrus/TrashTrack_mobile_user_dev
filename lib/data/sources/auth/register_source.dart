import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trashtrack_user/data/repositories/auth_repository.dart';
import 'package:trashtrack_user/models/credential/credential.dart';

class RegisterSource {
  FESST register(Credential credential) async {
    try {
      final firebaseAuth = FirebaseAuth.instance;

      final userCred = await firebaseAuth.createUserWithEmailAndPassword(
        email: credential.email,
        password: credential.password ?? '',
      );

      final firebaseFire = FirebaseFirestore.instance;
      final usersCol = firebaseFire.collection('users');

      final docRef = usersCol.doc(userCred.user?.uid);

      final userData = {
        'firstname': credential.firstname,
        'lastname': credential.lastname,
        'barangay': credential.barangay,
        'email': credential.email,
        'role': 'User',
      };

      await docRef.set(userData);

      return const Right('Register successful');
    } catch (e) {
      String error = 'Error signing up: $e';

      return Left(error);
    }
  }
}

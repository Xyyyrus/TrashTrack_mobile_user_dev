import 'package:dartz/dartz.dart';
import 'package:trashtrack_user/data/sources/auth/check_email_source.dart';
import 'package:trashtrack_user/data/sources/auth/forgot_source.dart';
import 'package:trashtrack_user/data/sources/auth/login_source.dart';
import 'package:trashtrack_user/data/sources/auth/logout_source.dart';
import 'package:trashtrack_user/data/sources/auth/register_source.dart';
import 'package:trashtrack_user/models/credential/credential.dart';

/// Type alias for Future of Either<String, String> to improve readability
typedef FESST = Future<Either<String, String>>;

/// Repository handling all authentication-related operations
class AuthRepository {
<<<<<<< HEAD
  final LoginSource loginSource;
  final LogoutSource logoutSource;
  final LoginSourceGoogle loginSourceGoogle;
  final RegisterSource registerSource;
  final ForgotSource forgotSource;
  final CheckEmailSource checkEmailSource;
=======
  LoginSource loginSource;
  LogoutSource logoutSource;
  RegisterSource registerSource;
  ForgotSource forgotSource;
>>>>>>> 1e77c47997af77dab89e0427b2db0e4d0829c202

  AuthRepository({
    required this.loginSource,
    required this.loginSourceGoogle,
    required this.logoutSource,
    required this.registerSource,
    required this.forgotSource,
    required this.checkEmailSource,
  });

<<<<<<< HEAD
  /// Performs email/password login
  /// Returns Either with error string on left or success string on right
  FESST login(Credential credential) async {
    try {
      return await loginSource.login(credential);
    } catch (e) {
      return Left('An unexpected error occurred: ${e.toString()}');
    }
=======
  FESST login(Credential credential) async {
    return await loginSource.login(credential);
>>>>>>> 1e77c47997af77dab89e0427b2db0e4d0829c202
  }

  FESST checkIfEmailExists(String email) async {
    try {
      return await checkEmailSource.checkEmail(email);
    } catch (e) {
      return Left('Email check failed: ${e.toString()}');
    }
  }

  /// Performs Google sign-in
  /// Returns Either with error string on left or success string on right
  FESST loginGoogle() async {
    try {
      return await loginSourceGoogle.loginGoogle();
    } catch (e) {
      return Left('Google sign-in failed: ${e.toString()}');
    }
  }

  /// Performs user logout
  /// Returns Either with error string on left or success string on right
  FESST logout() async {
    try {
      return await logoutSource.logout();
    } catch (e) {
      return Left('Logout failed: ${e.toString()}');
    }
  }

<<<<<<< HEAD
  /// Registers a new user
  /// Returns Either with error string on left or success string on right
  FESST register(Credential credential) async {
    try {
      return await registerSource.register(credential);
    } catch (e) {
      return Left('Registration failed: ${e.toString()}');
    }
  }

  /// Initiates password reset flow
  /// Returns Either with error string on left or success string on right
=======
  FESST register(Credential credential) async {
    return await registerSource.register(credential);
  }

>>>>>>> 1e77c47997af77dab89e0427b2db0e4d0829c202
  FESST forgot(Credential credential) async {
    try {
      return await forgotSource.forgot(credential);
    } catch (e) {
      return Left('Password reset failed: ${e.toString()}');
    }
  }
}

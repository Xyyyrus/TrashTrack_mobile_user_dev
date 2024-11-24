import 'package:dartz/dartz.dart';
import 'package:trashtrack_user/data/sources/auth/forgot_source.dart';
import 'package:trashtrack_user/data/sources/auth/login_source.dart';
import 'package:trashtrack_user/data/sources/auth/logout_source.dart';
import 'package:trashtrack_user/data/sources/auth/register_source.dart';
import 'package:trashtrack_user/models/credential/credential.dart';

typedef FESST = Future<Either<String, String>>;

class AuthRepository {
  LoginSource loginSource;
  LogoutSource logoutSource;
  RegisterSource registerSource;
  ForgotSource forgotSource;

  AuthRepository({
    required this.loginSource,
    required this.logoutSource,
    required this.registerSource,
    required this.forgotSource,
  });

  FESST login(Credential credential) async {
    return await loginSource.login(credential);
  }

  FESST logout() async {
    return await logoutSource.logout();
  }

  FESST register(Credential credential) async {
    return await registerSource.register(credential);
  }

  FESST forgot(Credential credential) async {
    return await forgotSource.forgot(credential);
  }
}

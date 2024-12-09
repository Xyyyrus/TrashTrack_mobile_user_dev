// part of 'login_bloc.dart';

// @immutable
// sealed class LoginEvent {}

// class LoginAccountEvent extends LoginEvent {
//   final Credential credential;

//   LoginAccountEvent(this.credential);
// }
// login_event.dart
part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginAccountEvent extends LoginEvent {
  final Credential credential;
<<<<<<< HEAD
  LoginAccountEvent(this.credential);
}

class LoginGoogleEvent extends LoginEvent {}
=======

  LoginAccountEvent(this.credential);
}
>>>>>>> 1e77c47997af77dab89e0427b2db0e4d0829c202

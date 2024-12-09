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
  LoginAccountEvent(this.credential);
}

class LoginGoogleEvent extends LoginEvent {}

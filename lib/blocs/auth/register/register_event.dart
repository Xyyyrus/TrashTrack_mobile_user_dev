part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {}

class RegisterAccountEvent extends RegisterEvent {
  final Credential credential;

  RegisterAccountEvent(this.credential);
}

class CheckEmailUniqueEvent extends RegisterEvent {
  final String email;

  CheckEmailUniqueEvent(this.email); // Remove 'const'
}

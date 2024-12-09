part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {}

class RegisterAccountEvent extends RegisterEvent {
  final Credential credential;

  RegisterAccountEvent(this.credential);
}
<<<<<<< HEAD

class CheckEmailUniqueEvent extends RegisterEvent {
  final String email;

  CheckEmailUniqueEvent(this.email); // Remove 'const'
}
=======
>>>>>>> 1e77c47997af77dab89e0427b2db0e4d0829c202

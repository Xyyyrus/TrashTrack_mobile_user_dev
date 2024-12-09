part of 'register_bloc.dart';

@immutable
sealed class RegisterState {}

class RegisterInitialState extends RegisterState {}

class RegisterProcessingState extends RegisterState {}

class RegisterSuccessfulState extends RegisterState {
  final String message;

  RegisterSuccessfulState(this.message);
}

<<<<<<< HEAD
class EmailCheckState extends RegisterState {
  final bool isUnique;
  final String? errorMessage;

  EmailCheckState({required this.isUnique, this.errorMessage});
}

=======
>>>>>>> 1e77c47997af77dab89e0427b2db0e4d0829c202
class RegisterErrorState extends RegisterState {
  final String message;

  RegisterErrorState(this.message);
}

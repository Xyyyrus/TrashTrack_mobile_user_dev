part of 'register_bloc.dart';

@immutable
sealed class RegisterState {}

class RegisterInitialState extends RegisterState {}

class RegisterProcessingState extends RegisterState {}

class RegisterSuccessfulState extends RegisterState {
  final String message;

  RegisterSuccessfulState(this.message);
}

class EmailCheckState extends RegisterState {
  final bool isUnique;
  final String? errorMessage;

  EmailCheckState({required this.isUnique, this.errorMessage});
}

class RegisterErrorState extends RegisterState {
  final String message;

  RegisterErrorState(this.message);
}

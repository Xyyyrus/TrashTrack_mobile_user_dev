part of 'register_bloc.dart';

@immutable
sealed class RegisterState {}

class RegisterInitialState extends RegisterState {}

class RegisterProcessingState extends RegisterState {}

class RegisterSuccessfulState extends RegisterState {
  final String message;

  RegisterSuccessfulState(this.message);
}

class RegisterErrorState extends RegisterState {
  final String message;

  RegisterErrorState(this.message);
}

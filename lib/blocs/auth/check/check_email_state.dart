abstract class CheckEmailState {}

class CheckEmailInitialState extends CheckEmailState {}

class CheckEmailLoadingState extends CheckEmailState {}

class CheckEmailExistsState extends CheckEmailState {
  final String message;
  CheckEmailExistsState({required this.message});
}

class CheckEmailValidState extends CheckEmailState {}

class CheckEmailErrorState extends CheckEmailState {
  final String message;
  CheckEmailErrorState({required this.message});
}

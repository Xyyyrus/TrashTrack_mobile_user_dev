import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:trashtrack_user/models/credential/credential.dart';
import 'package:trashtrack_user/data/repositories/auth_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository repository;

  LoginBloc(this.repository) : super(LoginInitialState()) {
    // Email login handler
    on<LoginAccountEvent>((event, emit) async {
      emit(LoginProcessingState());

      final result = await repository.login(event.credential);

      result.fold((error) => emit(LoginErrorState(error)),
          (success) => emit(LoginSuccessfulState(success)));
    });

    // Google login handler - this was missing before
    on<LoginGoogleEvent>((event, emit) async {
      emit(LoginProcessingState());

      final result = await repository.loginGoogle();

      result.fold((error) => emit(LoginErrorState(error)),
          (success) => emit(LoginSuccessfulState(success)));
    });
  }
}

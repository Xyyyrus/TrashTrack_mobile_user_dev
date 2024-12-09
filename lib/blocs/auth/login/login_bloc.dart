import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:trashtrack_user/models/credential/credential.dart';
import 'package:trashtrack_user/data/repositories/auth_repository.dart';
import 'package:trashtrack_user/models/credential/credential.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository repository;

  LoginBloc(this.repository) : super(LoginInitialState()) {
    // Email login handler
    on<LoginAccountEvent>((event, emit) async {
      emit(LoginProcessingState());

<<<<<<< HEAD
      final result = await repository.login(event.credential);
=======
      final ESST result = await repository.login(event.credential);
>>>>>>> 1e77c47997af77dab89e0427b2db0e4d0829c202

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

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashtrack_user/blocs/auth/check/check_email_event.dart';
import 'package:trashtrack_user/blocs/auth/check/check_email_state.dart';
import 'package:trashtrack_user/data/repositories/auth_repository.dart';

class CheckEmailBloc extends Bloc<CheckEmailEvent, CheckEmailState> {
  final AuthRepository authRepository;

  CheckEmailBloc({required this.authRepository})
      : super(CheckEmailInitialState());

  Stream<CheckEmailState> mapEventToState(CheckEmailEvent event) async* {
    yield CheckEmailLoadingState();

    try {
      // Ensure this returns a boolean
      final bool emailExists =
          (await authRepository.checkIfEmailExists(event.email)) as bool;

      if (emailExists) {
        yield CheckEmailExistsState(message: 'Email is already registered.');
      } else {
        yield CheckEmailValidState();
      }
    } catch (e) {
      yield CheckEmailErrorState(message: e.toString());
    }
  }
}

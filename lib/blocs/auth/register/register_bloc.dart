import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trashtrack_user/data/repositories/auth_repository.dart';
import 'package:trashtrack_user/models/credential/credential.dart';

part 'register_event.dart';
part 'register_state.dart';

typedef ESST = Either<String, String>;

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository repository;

  RegisterBloc(this.repository) : super(RegisterInitialState()) {
    on<RegisterAccountEvent>((event, emit) async {
      emit(RegisterProcessingState());

      final ESST result = await repository.register(event.credential);

      result.fold((String l) {
        emit(RegisterErrorState(l));
      }, (String r) {
        emit(RegisterSuccessfulState(r));
      });
    });
  }
}

import 'package:trashtrack_user/blocs/auth/login/login_bloc.dart';

class CheckEmailEvent extends LoginEvent {
  final String email;

  CheckEmailEvent({required this.email});
}

// auth_cubit.dart
import 'package:bloc/bloc.dart';

enum AuthState { authenticated, unauthenticated }

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState.unauthenticated);

  void authenticate() {
    emit(AuthState.authenticated);
  }

  void unauthenticate() {
    emit(AuthState.unauthenticated);
  }
}

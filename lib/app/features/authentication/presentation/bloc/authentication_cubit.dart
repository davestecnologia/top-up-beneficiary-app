import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_up_beneficiary_app/app/features/authentication/domain/usecases/login_usecase.dart';

abstract class AuthenticationState {}

class Unauthenticated extends AuthenticationState {}

class Authenticated extends AuthenticationState {}

class Loading extends AuthenticationState {}

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final LoginUseCase loginUseCase;

  AuthenticationCubit(this.loginUseCase) : super(Unauthenticated());

  Future<void> login(String username, String password) async {
    emit(Loading());
    final isAuthenticated = await loginUseCase(username, password);
    if (isAuthenticated) {
      emit(Authenticated());
    } else {
      emit(Unauthenticated());
    }
  }

  void logout() {
    emit(Unauthenticated());
  }
}

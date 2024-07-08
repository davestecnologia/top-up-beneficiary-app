import 'package:top_up_beneficiary_app/app/features/authentication/domain/repositories/autenthication_repository.dart';

class LoginUseCase {
  final AuthenticationRepository repository;

  LoginUseCase(this.repository);

  Future<bool> call(String username, String password) async {
    return await repository.login(username, password);
  }
}

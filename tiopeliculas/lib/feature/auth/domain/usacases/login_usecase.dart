import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<String> call(String email, String password) =>
      _repository.login(email, password);
}

import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<void> call(String email, String password) =>
      _repository.register(email, password);
}

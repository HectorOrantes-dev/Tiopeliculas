import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/api/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _datasource;

  AuthRepositoryImpl(this._datasource);

  @override
  Future<String> login(String email, String password) =>
      _datasource.login(email, password);

  @override
  Future<void> register(String email, String password) =>
      _datasource.register(email, password);
}

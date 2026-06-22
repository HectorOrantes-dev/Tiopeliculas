import '../../../core/di/app_di.dart';
import '../data/datasources/remote/api/auth_remote_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/usacases/login_usecase.dart';
import '../domain/usacases/register_usecase.dart';
import '../presentation/providers/auth_provider.dart';

class AuthDI {
  AuthDI._();

  static AuthRemoteDatasource get _datasource =>
      AuthRemoteDatasource(AppDI.httpClient);

  static AuthRepositoryImpl get _repository =>
      AuthRepositoryImpl(_datasource);

  static LoginUseCase get _loginUseCase => LoginUseCase(_repository);
  static RegisterUseCase get _registerUseCase => RegisterUseCase(_repository);

  static AuthProvider get authProvider => AuthProvider(
        loginUseCase: _loginUseCase,
        registerUseCase: _registerUseCase,
        tokenStorage: AppDI.tokenStorage,
      );
}

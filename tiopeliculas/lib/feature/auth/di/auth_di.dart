import '../../../core/di/app_di.dart';
import '../data/datasources/remote/api/auth_remote_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usacases/login_usecase.dart';
import '../domain/usacases/register_usecase.dart';
import '../presentation/providers/auth_provider.dart';

/// Inyección de dependencias manual del feature Auth.
///
/// Cada dependencia es una instancia única (singleton perezoso con
/// `static final`) y se ensambla a mano pasándola por constructor,
/// sin librerías de DI.
class AuthDI {
  AuthDI._();

  // Data
  static final AuthRemoteDatasource _datasource =
      AuthRemoteDatasource(AppDI.httpClient);

  static final AuthRepository _repository = AuthRepositoryImpl(_datasource);

  // Domain (casos de uso)
  static final LoginUseCase _loginUseCase = LoginUseCase(_repository);
  static final RegisterUseCase _registerUseCase = RegisterUseCase(_repository);

  // Presentation: el ViewModel se crea bajo demanda para que Provider
  // gestione su ciclo de vida (dispose).
  static AuthProvider createProvider() => AuthProvider(
        loginUseCase: _loginUseCase,
        registerUseCase: _registerUseCase,
        tokenStorage: AppDI.tokenStorage,
      );
}

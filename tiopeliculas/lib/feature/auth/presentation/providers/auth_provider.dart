import 'package:flutter/foundation.dart';

import '../../../../core/di/token_storage.dart';
import '../../../../core/mixins/network_error_mixin.dart';
import '../../../../core/mixins/view_state_mixin.dart';
import '../../domain/usacases/login_usecase.dart';
import '../../domain/usacases/register_usecase.dart';

/// ViewModel de autenticación.
///
/// No usa herencia: compone su comportamiento con mixins
/// ([ChangeNotifier] + [ViewStateMixin] + [NetworkErrorMixin]).
class AuthProvider with ChangeNotifier, ViewStateMixin, NetworkErrorMixin {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final TokenStorage _tokenStorage;

  AuthProvider({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required TokenStorage tokenStorage,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _tokenStorage = tokenStorage;

  bool get isAuthenticated => _tokenStorage.isAuthenticated;

  Future<bool> login(String email, String password) async {
    setLoading();
    try {
      final token = await _loginUseCase(email, password);
      _tokenStorage.save(token);
      setSuccess();
      return true;
    } catch (e) {
      setError(_loginError(e));
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    setLoading();
    try {
      await _registerUseCase(email, password);
      setSuccess();
      return true;
    } catch (e) {
      setError(_registerError(e));
      return false;
    }
  }

  void logout() {
    _tokenStorage.clear();
    setIdle();
  }

  String _loginError(Object e) {
    final msg = e.toString();
    if (msg.contains('401') || msg.contains('Unauthorized')) {
      return 'Credenciales incorrectas';
    }
    if (msg.contains('404')) return 'Usuario no encontrado';
    return mapNetworkError(e);
  }

  String _registerError(Object e) {
    final msg = e.toString();
    if (msg.contains('409') || msg.contains('Conflict')) {
      return 'Este correo ya está registrado';
    }
    if (msg.contains('400')) {
      return 'Datos inválidos. Verifica el correo y la contraseña.';
    }
    return extractServerMessage(e) ?? mapNetworkError(e);
  }
}

import 'package:flutter/foundation.dart';

import '../../../../core/di/token_storage.dart';
import '../../domain/usacases/login_usecase.dart';
import '../../domain/usacases/register_usecase.dart';

enum AuthViewState { idle, loading, success, error }

class AuthProvider extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final TokenStorage _tokenStorage;

  AuthViewState _state = AuthViewState.idle;
  String? _errorMessage;

  AuthProvider({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required TokenStorage tokenStorage,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _tokenStorage = tokenStorage;

  AuthViewState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _tokenStorage.isAuthenticated;
  bool get isLoading => _state == AuthViewState.loading;

  Future<bool> login(String email, String password) async {
    _setState(AuthViewState.loading);
    try {
      final token = await _loginUseCase(email, password);
      _tokenStorage.save(token);
      _setState(AuthViewState.success);
      return true;
    } catch (e) {
      _errorMessage = _parseError(e);
      _setState(AuthViewState.error);
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    _setState(AuthViewState.loading);
    try {
      await _registerUseCase(email, password);
      _setState(AuthViewState.success);
      return true;
    } catch (e) {
      _errorMessage = _parseRegisterError(e);
      _setState(AuthViewState.error);
      return false;
    }
  }

  void logout() {
    _tokenStorage.clear();
    _state = AuthViewState.idle;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    if (_state == AuthViewState.error) _state = AuthViewState.idle;
    notifyListeners();
  }

  void _setState(AuthViewState s) {
    _state = s;
    notifyListeners();
  }

  String _parseError(Object e) {
    final msg = e.toString();
    if (msg.contains('SocketException') || msg.contains('Connection refused')) {
      return 'Sin conexión con el servidor';
    }
    if (msg.contains('401') || msg.contains('Unauthorized')) {
      return 'Credenciales incorrectas';
    }
    if (msg.contains('404')) return 'Usuario no encontrado';
    if (msg.contains('409') || msg.contains('Conflict')) {
      return 'Este correo ya está registrado';
    }
    return 'Ocurrió un error. Intenta de nuevo.';
  }

  String _parseRegisterError(Object e) {
    final msg = e.toString();
    if (msg.contains('SocketException') || msg.contains('Connection refused')) {
      return 'Sin conexión con el servidor';
    }
    if (msg.contains('409') || msg.contains('Conflict')) {
      return 'Este correo ya está registrado';
    }
    if (msg.contains('400')) return 'Datos inválidos. Verifica el correo y la contraseña.';
    if (msg.contains('404')) return 'Servicio no disponible. Intenta más tarde.';
    if (msg.contains('500')) return 'Error interno del servidor. Intenta más tarde.';
    // Mostrar el mensaje real del servidor si está disponible
    final serverMsgMatch = RegExp(r'Registro fallido \(\d+\): (.+)').firstMatch(msg);
    if (serverMsgMatch != null) {
      final serverMsg = serverMsgMatch.group(1) ?? '';
      if (serverMsg.isNotEmpty && serverMsg != 'Sin respuesta del servidor') {
        return serverMsg;
      }
    }
    return 'No se pudo completar el registro. Intenta de nuevo.';
  }
}

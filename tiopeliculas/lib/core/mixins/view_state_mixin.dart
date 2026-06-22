import 'package:flutter/foundation.dart';

/// Estados posibles de una vista (ViewModel) en toda la app.
enum ViewState { idle, loading, success, error }

/// Mixin que aporta el manejo de estado (idle/loading/success/error) y el
/// mensaje de error a cualquier ViewModel.
///
/// Está restringido `on ChangeNotifier` para poder invocar [notifyListeners]
/// sin heredar de ninguna clase base propia: el ViewModel solo necesita
/// mezclar `ChangeNotifier` y este mixin.
mixin ViewStateMixin on ChangeNotifier {
  ViewState _state = ViewState.idle;
  String? _errorMessage;

  ViewState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == ViewState.loading;
  bool get hasError => _state == ViewState.error;

  void setIdle() => _emit(ViewState.idle);
  void setLoading() => _emit(ViewState.loading);
  void setSuccess() => _emit(ViewState.success);

  void setError(String message) {
    _errorMessage = message;
    _emit(ViewState.error);
  }

  void clearError() {
    if (_state == ViewState.error) {
      _errorMessage = null;
      _emit(ViewState.idle);
    }
  }

  void _emit(ViewState next) {
    _state = next;
    notifyListeners();
  }
}

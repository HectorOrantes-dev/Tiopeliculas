import 'package:flutter/foundation.dart';

import '../../domain/entities/pelicula_entity.dart';
import '../../domain/usacases/create_pelicula_usecase.dart';
import '../../domain/usacases/delete_pelicula_usecase.dart';
import '../../domain/usacases/get_peliculas_usecase.dart';
import '../../domain/usacases/update_pelicula_usecase.dart';

enum PeliculasViewState { idle, loading, success, error }

class PeliculasProvider extends ChangeNotifier {
  final GetPeliculasUseCase _getUseCase;
  final CreatePeliculaUseCase _createUseCase;
  final UpdatePeliculaUseCase _updateUseCase;
  final DeletePeliculaUseCase _deleteUseCase;

  PeliculasViewState _state = PeliculasViewState.idle;
  List<PeliculaEntity> _peliculas = [];
  String? _errorMessage;

  PeliculasProvider({
    required GetPeliculasUseCase getPeliculasUseCase,
    required CreatePeliculaUseCase createPeliculaUseCase,
    required UpdatePeliculaUseCase updatePeliculaUseCase,
    required DeletePeliculaUseCase deletePeliculaUseCase,
  })  : _getUseCase = getPeliculasUseCase,
        _createUseCase = createPeliculaUseCase,
        _updateUseCase = updatePeliculaUseCase,
        _deleteUseCase = deletePeliculaUseCase;

  PeliculasViewState get state => _state;
  List<PeliculaEntity> get peliculas => List.unmodifiable(_peliculas);
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == PeliculasViewState.loading;

  Future<void> loadPeliculas() async {
    _setState(PeliculasViewState.loading);
    try {
      _peliculas = await _getUseCase();
      _setState(PeliculasViewState.success);
    } catch (e) {
      _errorMessage = _parseError(e);
      _setState(PeliculasViewState.error);
    }
  }

  Future<bool> createPelicula(PeliculaEntity pelicula) async {
    _setState(PeliculasViewState.loading);
    try {
      await _createUseCase(pelicula);
      await loadPeliculas();
      return true;
    } catch (e) {
      _errorMessage = _parseError(e);
      _setState(PeliculasViewState.error);
      return false;
    }
  }

  Future<bool> updatePelicula(String id, PeliculaEntity pelicula) async {
    _setState(PeliculasViewState.loading);
    try {
      await _updateUseCase(id, pelicula);
      await loadPeliculas();
      return true;
    } catch (e) {
      _errorMessage = _parseError(e);
      _setState(PeliculasViewState.error);
      return false;
    }
  }

  Future<bool> deletePelicula(String id) async {
    try {
      await _deleteUseCase(id);
      _peliculas.removeWhere((p) => p.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = _parseError(e);
      _setState(PeliculasViewState.error);
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    if (_state == PeliculasViewState.error) _state = PeliculasViewState.idle;
    notifyListeners();
  }

  void _setState(PeliculasViewState s) {
    _state = s;
    notifyListeners();
  }

  String _parseError(Object e) {
    final msg = e.toString();
    if (msg.contains('SocketException') || msg.contains('Connection refused')) {
      return 'Sin conexión con el servidor';
    }
    if (msg.contains('401') || msg.contains('Unauthorized')) {
      return 'Sesión expirada. Inicia sesión nuevamente.';
    }
    if (msg.contains('404')) return 'Película no encontrada';
    return 'Ocurrió un error. Intenta de nuevo.';
  }
}

import 'package:flutter/foundation.dart';

import '../../../../core/mixins/network_error_mixin.dart';
import '../../../../core/mixins/view_state_mixin.dart';
import '../../domain/entities/pelicula_entity.dart';
import '../../domain/usacases/create_pelicula_usecase.dart';
import '../../domain/usacases/delete_pelicula_usecase.dart';
import '../../domain/usacases/get_peliculas_usecase.dart';
import '../../domain/usacases/update_pelicula_usecase.dart';

/// ViewModel del catálogo de películas.
///
/// No usa herencia: compone su comportamiento con mixins
/// ([ChangeNotifier] + [ViewStateMixin] + [NetworkErrorMixin]).
class PeliculasProvider with ChangeNotifier, ViewStateMixin, NetworkErrorMixin {
  final GetPeliculasUseCase _getUseCase;
  final CreatePeliculaUseCase _createUseCase;
  final UpdatePeliculaUseCase _updateUseCase;
  final DeletePeliculaUseCase _deleteUseCase;

  List<PeliculaEntity> _peliculas = [];

  PeliculasProvider({
    required GetPeliculasUseCase getPeliculasUseCase,
    required CreatePeliculaUseCase createPeliculaUseCase,
    required UpdatePeliculaUseCase updatePeliculaUseCase,
    required DeletePeliculaUseCase deletePeliculaUseCase,
  })  : _getUseCase = getPeliculasUseCase,
        _createUseCase = createPeliculaUseCase,
        _updateUseCase = updatePeliculaUseCase,
        _deleteUseCase = deletePeliculaUseCase;

  List<PeliculaEntity> get peliculas => List.unmodifiable(_peliculas);

  Future<void> loadPeliculas() async {
    setLoading();
    try {
      _peliculas = await _getUseCase();
      setSuccess();
    } catch (e) {
      setError(_peliculasError(e));
    }
  }

  Future<bool> createPelicula(PeliculaEntity pelicula) async {
    setLoading();
    try {
      await _createUseCase(pelicula);
      await loadPeliculas();
      return true;
    } catch (e) {
      setError(_peliculasError(e));
      return false;
    }
  }

  Future<bool> updatePelicula(String id, PeliculaEntity pelicula) async {
    setLoading();
    try {
      await _updateUseCase(id, pelicula);
      await loadPeliculas();
      return true;
    } catch (e) {
      setError(_peliculasError(e));
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
      setError(_peliculasError(e));
      return false;
    }
  }

  String _peliculasError(Object e) {
    final msg = e.toString();
    if (msg.contains('401') || msg.contains('Unauthorized')) {
      return 'Sesión expirada. Inicia sesión nuevamente.';
    }
    if (msg.contains('404')) return 'Película no encontrada';
    return mapNetworkError(e);
  }
}

import '../../../core/di/app_di.dart';
import '../data/datasources/remote/api/peliculas_remote_datasource.dart';
import '../data/repositories/peliculas_repository_impl.dart';
import '../domain/repositories/peliculas_repository.dart';
import '../domain/usacases/create_pelicula_usecase.dart';
import '../domain/usacases/delete_pelicula_usecase.dart';
import '../domain/usacases/get_peliculas_usecase.dart';
import '../domain/usacases/update_pelicula_usecase.dart';
import '../presentation/providers/peliculas_provider.dart';

/// Inyección de dependencias manual del feature Películas.
///
/// Cada dependencia es una instancia única (singleton perezoso con
/// `static final`) y se ensambla a mano pasándola por constructor,
/// sin librerías de DI. Comparte `httpClient` y `tokenStorage` con el
/// resto de la app a través de [AppDI].
class PeliculasDI {
  PeliculasDI._();

  // Data
  static final PeliculasRemoteDatasource _datasource =
      PeliculasRemoteDatasource(AppDI.httpClient, AppDI.tokenStorage);

  static final PeliculasRepository _repository =
      PeliculasRepositoryImpl(_datasource);

  // Domain (casos de uso)
  static final GetPeliculasUseCase _getUseCase =
      GetPeliculasUseCase(_repository);
  static final CreatePeliculaUseCase _createUseCase =
      CreatePeliculaUseCase(_repository);
  static final UpdatePeliculaUseCase _updateUseCase =
      UpdatePeliculaUseCase(_repository);
  static final DeletePeliculaUseCase _deleteUseCase =
      DeletePeliculaUseCase(_repository);

  // Presentation: el ViewModel se crea bajo demanda para que Provider
  // gestione su ciclo de vida (dispose).
  static PeliculasProvider createProvider() => PeliculasProvider(
        getPeliculasUseCase: _getUseCase,
        createPeliculaUseCase: _createUseCase,
        updatePeliculaUseCase: _updateUseCase,
        deletePeliculaUseCase: _deleteUseCase,
      );
}

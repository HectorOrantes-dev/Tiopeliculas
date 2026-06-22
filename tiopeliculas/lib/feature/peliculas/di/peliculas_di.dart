import '../../../core/di/app_di.dart';
import '../data/datasources/remote/api/peliculas_remote_datasource.dart';
import '../data/repositories/peliculas_repository_impl.dart';
import '../domain/usacases/create_pelicula_usecase.dart';
import '../domain/usacases/delete_pelicula_usecase.dart';
import '../domain/usacases/get_peliculas_usecase.dart';
import '../domain/usacases/update_pelicula_usecase.dart';
import '../presentation/providers/peliculas_provider.dart';

class PeliculasDI {
  PeliculasDI._();

  static PeliculasRemoteDatasource get _datasource =>
      PeliculasRemoteDatasource(AppDI.httpClient, AppDI.tokenStorage);

  static PeliculasRepositoryImpl get _repository =>
      PeliculasRepositoryImpl(_datasource);

  static GetPeliculasUseCase get _getUseCase =>
      GetPeliculasUseCase(_repository);
  static CreatePeliculaUseCase get _createUseCase =>
      CreatePeliculaUseCase(_repository);
  static UpdatePeliculaUseCase get _updateUseCase =>
      UpdatePeliculaUseCase(_repository);
  static DeletePeliculaUseCase get _deleteUseCase =>
      DeletePeliculaUseCase(_repository);

  static PeliculasProvider get peliculasProvider => PeliculasProvider(
        getPeliculasUseCase: _getUseCase,
        createPeliculaUseCase: _createUseCase,
        updatePeliculaUseCase: _updateUseCase,
        deletePeliculaUseCase: _deleteUseCase,
      );
}

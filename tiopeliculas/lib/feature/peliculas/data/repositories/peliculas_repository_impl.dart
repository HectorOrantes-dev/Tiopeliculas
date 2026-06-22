import '../../domain/entities/pelicula_entity.dart';
import '../../domain/repositories/peliculas_repository.dart';
import '../datasources/remote/api/peliculas_remote_datasource.dart';

class PeliculasRepositoryImpl implements PeliculasRepository {
  final PeliculasRemoteDatasource _datasource;

  PeliculasRepositoryImpl(this._datasource);

  @override
  Future<List<PeliculaEntity>> getPeliculas() => _datasource.getPeliculas();

  @override
  Future<void> createPelicula(PeliculaEntity pelicula) =>
      _datasource.createPelicula(pelicula);

  @override
  Future<void> updatePelicula(String id, PeliculaEntity pelicula) =>
      _datasource.updatePelicula(id, pelicula);

  @override
  Future<void> deletePelicula(String id) => _datasource.deletePelicula(id);
}

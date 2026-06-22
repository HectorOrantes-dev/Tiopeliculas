import '../entities/pelicula_entity.dart';
import '../repositories/peliculas_repository.dart';

class GetPeliculasUseCase {
  final PeliculasRepository _repository;

  GetPeliculasUseCase(this._repository);

  Future<List<PeliculaEntity>> call() => _repository.getPeliculas();
}

import '../entities/pelicula_entity.dart';
import '../repositories/peliculas_repository.dart';

class UpdatePeliculaUseCase {
  final PeliculasRepository _repository;

  UpdatePeliculaUseCase(this._repository);

  Future<void> call(String id, PeliculaEntity pelicula) =>
      _repository.updatePelicula(id, pelicula);
}

import '../entities/pelicula_entity.dart';
import '../repositories/peliculas_repository.dart';

class CreatePeliculaUseCase {
  final PeliculasRepository _repository;

  CreatePeliculaUseCase(this._repository);

  Future<void> call(PeliculaEntity pelicula) =>
      _repository.createPelicula(pelicula);
}

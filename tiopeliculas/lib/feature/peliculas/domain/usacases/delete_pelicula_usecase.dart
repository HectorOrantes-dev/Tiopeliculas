import '../repositories/peliculas_repository.dart';

class DeletePeliculaUseCase {
  final PeliculasRepository _repository;

  DeletePeliculaUseCase(this._repository);

  Future<void> call(String id) => _repository.deletePelicula(id);
}

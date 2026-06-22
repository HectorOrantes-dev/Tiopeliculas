import '../entities/pelicula_entity.dart';

abstract class PeliculasRepository {
  Future<List<PeliculaEntity>> getPeliculas();
  Future<void> createPelicula(PeliculaEntity pelicula);
  Future<void> updatePelicula(String id, PeliculaEntity pelicula);
  Future<void> deletePelicula(String id);
}

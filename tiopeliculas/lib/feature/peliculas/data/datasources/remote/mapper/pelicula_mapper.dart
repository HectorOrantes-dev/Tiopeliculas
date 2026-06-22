import '../../../../domain/entities/pelicula_entity.dart';
import '../model/pelicula_model.dart';

class PeliculaMapper {
  PeliculaMapper._();

  static PeliculaEntity toEntity(PeliculaModel model) => PeliculaEntity(
        id: model.id,
        titulo: model.titulo,
        genero: model.genero,
        anio: model.anio,
        descripcion: model.descripcion,
      );

  static PeliculaModel fromEntity(PeliculaEntity entity) => PeliculaModel(
        id: entity.id,
        titulo: entity.titulo,
        genero: entity.genero,
        anio: entity.anio,
        descripcion: entity.descripcion,
      );

  static List<PeliculaEntity> toEntityList(List<PeliculaModel> models) =>
      models.map(toEntity).toList();
}

class PeliculaEntity {
  final String id;
  final String titulo;
  final String genero;
  final int anio;
  final String descripcion;

  const PeliculaEntity({
    required this.id,
    required this.titulo,
    required this.genero,
    required this.anio,
    required this.descripcion,
  });

  PeliculaEntity copyWith({
    String? id,
    String? titulo,
    String? genero,
    int? anio,
    String? descripcion,
  }) =>
      PeliculaEntity(
        id: id ?? this.id,
        titulo: titulo ?? this.titulo,
        genero: genero ?? this.genero,
        anio: anio ?? this.anio,
        descripcion: descripcion ?? this.descripcion,
      );
}

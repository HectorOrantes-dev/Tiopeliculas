class PeliculaModel {
  final String id;
  final String titulo;
  final String genero;
  final int anio;
  final String descripcion;

  const PeliculaModel({
    required this.id,
    required this.titulo,
    required this.genero,
    required this.anio,
    required this.descripcion,
  });

  factory PeliculaModel.fromJson(Map<String, dynamic> json) => PeliculaModel(
        id: json['id']?.toString() ?? '',
        titulo: json['titulo']?.toString() ?? '',
        genero: json['genero']?.toString() ?? '',
        anio: (json['anio'] as num?)?.toInt() ?? 0,
        descripcion: json['descripcion']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'titulo': titulo,
        'genero': genero,
        'anio': anio,
        'descripcion': descripcion,
      };
}

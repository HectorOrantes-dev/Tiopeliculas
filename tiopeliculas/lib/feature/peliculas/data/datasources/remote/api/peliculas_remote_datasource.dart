import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../../../core/di/token_storage.dart';
import '../mapper/pelicula_mapper.dart';
import '../model/pelicula_model.dart';
import '../../../../domain/entities/pelicula_entity.dart';

class PeliculasRemoteDatasource {
  final http.Client _client;
  final TokenStorage _tokenStorage;
  static const _baseUrl = 'https://medicgo.sbs';

  PeliculasRemoteDatasource(this._client, this._tokenStorage);

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_tokenStorage.token != null)
          'Authorization': 'Bearer ${_tokenStorage.token}',
      };

  Future<List<PeliculaEntity>> getPeliculas() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/peliculas'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      final models = list
          .map((e) => PeliculaModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return PeliculaMapper.toEntityList(models);
    }

    throw Exception(
        'Error al obtener películas (${response.statusCode}): ${response.body}');
  }

  Future<void> createPelicula(PeliculaEntity pelicula) async {
    final model = PeliculaMapper.fromEntity(pelicula);
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/peliculas'),
      headers: _headers,
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception(
          'Error al crear película (${response.statusCode}): ${response.body}');
    }
  }

  Future<void> updatePelicula(String id, PeliculaEntity pelicula) async {
    final model = PeliculaMapper.fromEntity(pelicula);
    final response = await _client.put(
      Uri.parse('$_baseUrl/api/peliculas/$id'),
      headers: _headers,
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Error al actualizar película (${response.statusCode}): ${response.body}');
    }
  }

  Future<void> deletePelicula(String id) async {
    final response = await _client.delete(
      Uri.parse('$_baseUrl/api/peliculas/$id'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Error al eliminar película (${response.statusCode}): ${response.body}');
    }
  }
}

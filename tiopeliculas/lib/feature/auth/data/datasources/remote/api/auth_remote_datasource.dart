import 'dart:convert';
import 'package:http/http.dart' as http;

import '../mapper/auth_mapper.dart';
import '../model/auth_request_model.dart';
import '../model/auth_response_model.dart';

class AuthRemoteDatasource {
  final http.Client _client;
  static const _baseUrl = 'https://medicgo.sbs';

  AuthRemoteDatasource(this._client);

  Future<String> login(String email, String password) async {
    final body = AuthRequestModel(email: email, password: password);
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body.toJson()),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return AuthMapper.toToken(AuthResponseModel.fromJson(json));
    }

    throw Exception('Login fallido (${response.statusCode}): ${response.body}');
  }

  Future<void> register(String email, String password) async {
    final body = AuthRequestModel(email: email, password: password);
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body.toJson()),
    );

    // Acepta 200 o 201 como éxito
    if (response.statusCode != 201 && response.statusCode != 200) {
      final serverMsg = _extractMessage(response.body);
      throw Exception(
          'Registro fallido (${response.statusCode}): $serverMsg');
    }
  }

  String _extractMessage(String body) {
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      for (final key in ['message', 'error', 'msg', 'detail', 'description']) {
        if (json.containsKey(key) && json[key] != null) {
          return json[key].toString();
        }
      }
      if (json.isNotEmpty) return json.values.first.toString();
    } catch (_) {}
    return body.isNotEmpty ? body : 'Sin respuesta del servidor';
  }
}

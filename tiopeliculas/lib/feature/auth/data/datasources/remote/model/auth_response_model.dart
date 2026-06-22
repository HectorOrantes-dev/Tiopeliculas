class AuthResponseModel {
  final String token;

  const AuthResponseModel({required this.token});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    for (final key in ['token', 'access_token', 'accessToken', 'jwt']) {
      if (json.containsKey(key) && json[key] != null) {
        return AuthResponseModel(token: json[key].toString());
      }
    }
    final first = json.values.firstWhere(
      (v) => v != null && v.toString().isNotEmpty,
      orElse: () => '',
    );
    return AuthResponseModel(token: first.toString());
  }
}

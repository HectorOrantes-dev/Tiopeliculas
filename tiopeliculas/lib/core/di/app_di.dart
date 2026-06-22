import 'package:http/http.dart' as http;
import 'token_storage.dart';

class AppDI {
  AppDI._();

  static final http.Client httpClient = http.Client();
  static final TokenStorage tokenStorage = TokenStorage();
}

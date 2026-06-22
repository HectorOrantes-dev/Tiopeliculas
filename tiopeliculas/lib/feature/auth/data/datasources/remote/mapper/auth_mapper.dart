import '../model/auth_response_model.dart';

class AuthMapper {
  AuthMapper._();

  static String toToken(AuthResponseModel model) => model.token;
}

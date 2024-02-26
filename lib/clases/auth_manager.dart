import 'dart:convert';
import 'package:http/http.dart' as http;
import '../clases/message_manager.dart';


class Auth_Manager {
  factory Auth_Manager() => _instance;

  Auth_Manager._internal();
  static final Auth_Manager _instance = Auth_Manager._internal();

  String? _accessToken;
  DateTime? _tokenExpiration;

  String? get accessToken => _accessToken;

  Future<void> refreshAccessToken() async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://webapicuv.urvaseo.com:8081/wbsWebsisApp/api/login/authenticate?AspxAutoDetectCookieSupport=1'),
        body: jsonEncode({
          "Username": "admin",
          "Password": "@C0n\$Li&3r..!23",
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final dynamic responseJson = jsonDecode(response.body);

        if (responseJson is String) {
          _accessToken = responseJson;
          _tokenExpiration = DateTime.now().add(Duration(minutes: 30));
        } else if (responseJson is Map<String, dynamic> &&
            responseJson.containsKey('token')) {
          _accessToken = responseJson['token'] as String;
          _tokenExpiration = DateTime.now().add(Duration(minutes: 30));
        } else {
          throw Exception('Error de autenticación: respuesta inesperada.');
        }
      } else {
        throw Exception('Error de autenticación: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener el token: $e');
    }
  }

  Future<bool> isTokenValid() async {
    if (_tokenExpiration != null) {
      // Compara la fecha de expiración del token con la fecha actual
      return DateTime.now().isBefore(_tokenExpiration!);
    }
    return false; // Si no hay fecha de expiración, consideramos que el token no es válido
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;

class Auth_Manager {

  factory Auth_Manager() => _instance;

  Auth_Manager._internal();
  static final Auth_Manager _instance = Auth_Manager._internal();

  String? _accessToken;
  DateTime? _tokenExpiration; // Nueva propiedad para almacenar la fecha de expiración del token

  String? get accessToken => _accessToken;

  Future<void> refreshAccessToken() async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://cscsrv002.consorcio.com:8081/wbsWebsisApp/api/login/authenticate?AspxAutoDetectCookieSupport=1'),
        body: jsonEncode({
          "Username": "admin",
          "Password": "@C0n\$Li&3r..!23",
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(
            response.body) as Map<String, dynamic>;

        _accessToken = responseData['token'] as String;

        // Actualiza la fecha de expiración del token según la respuesta específica de tu servicio
        _tokenExpiration = DateTime.now().add(
            Duration(minutes: 30)); // Ejemplo: 30 minutos de duración del token

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
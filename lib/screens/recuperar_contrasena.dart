import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../clases/auth_manager.dart';
import '../clases/message_manager.dart';
import 'login_screen.dart';

class RecuperarContrasenaScreen extends StatefulWidget {
  @override
  _RecuperarContrasenaScreenState createState() =>
      _RecuperarContrasenaScreenState();
}

class _RecuperarContrasenaScreenState extends State<RecuperarContrasenaScreen> {
  Auth_Manager authManager = Auth_Manager();
  TextEditingController _emailController = TextEditingController();

  void _recuperarContrasena() async {
    String email = _emailController.text;

    try {
      // Obtener el token actual
      bool isTokenValid = await authManager.isTokenValid();

      if (!isTokenValid) {
        await authManager.refreshAccessToken();
      }

      String? accessToken = authManager.accessToken;



      // Llamada a la API para recuperar la contraseña
      final response = await http.post(
        Uri.parse('http://webapicuv.urvaseo.com:8081/wbsWebsisApp/api/Recupera_Contrasena/postall?AspxAutoDetectCookieSupport=1'),
        body: jsonEncode({'_USUARIO': email}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      final dynamic responseJson = jsonDecode(response.body);

      String? message;
      String? result;

      if (responseJson is List && responseJson.isNotEmpty) {
        final Map<String, dynamic> responseData = responseJson[0] as Map<String, dynamic>;
        message = responseData['MENSSAGE']?.toString();
      } else if (responseJson is Map<String, dynamic>) {
        message = responseJson['MENSSAGE']?.toString();
      } else if (responseJson is String) {
        try {
          final dynamic parsedJson = jsonDecode(responseJson);

          if (parsedJson is Map<String, dynamic>) {
            message = parsedJson['MENSSAGE']?.toString();
            result = parsedJson['RESULTADO']?.toString();
          } else if (parsedJson is List) {
            if (parsedJson.isNotEmpty && parsedJson[0] is Map<String, dynamic>) {
              final Map<String, dynamic> responseData = parsedJson[0] as Map<String, dynamic>;
              message = responseData['MENSSAGE']?.toString();
              result = responseData['RESULTADO']?.toString();
              if (result=='OK'){
                MessageManager.showMessage(context, 'Mensaje: $message', MessageType.success);
                await Future.delayed(Duration(seconds: 5)); // Ajusta el tiempo según sea necesario
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => LoginScreen()),);

              }else {
                MessageManager.showMessage(context, 'Mensaje: $message', MessageType.error);
              }



            } else {
              print('La respuesta del servidor no es un formato JSON esperado');
              return;
            }
          } else {
            print('La respuesta del servidor no es un formato JSON esperado');
            return;
          }
        } catch (e) {
          print('Error al decodificar la cadena JSON: $e');
          return;
        }
      } else {
        print('Tipo de respuesta inesperado: ${responseJson.runtimeType}');
        return;
      }

      if (message != null) {
        // Puedes mostrar el mensaje o hacer lo que necesites con él
        print('Mensaje: $message');
        // Aquí puedes añadir lógica para mostrar el mensaje al usuario

        // En este caso, no necesitas regresar a la pantalla de inicio de sesión
      } else {
        print('El campo MENSSAGE no está presente o es nulo en la respuesta del servidor');
      }

    } catch (e) {
      print('Error al realizar la solicitud HTTP: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recuperar Contraseña'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo Electrónico'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _recuperarContrasena,
              style: ElevatedButton.styleFrom(
                primary: Colors.lightBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text('Recuperar Contraseña'),
            ),
          ],
        ),
      ),
    );
  }
}

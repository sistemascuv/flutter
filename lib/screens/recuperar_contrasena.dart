import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../clases/auth_manager.dart';
import '../clases/message_manager.dart';
import 'login_screen.dart';

class RecuperarContrasenaScreen extends StatefulWidget {
  @override
  _RecuperarContrasenaScreenState createState() =>
      _RecuperarContrasenaScreenState();
}

class _RecuperarContrasenaScreenState
    extends State<RecuperarContrasenaScreen> {
  Auth_Manager authManager = Auth_Manager();
  TextEditingController _emailController = TextEditingController();

  void _recuperarContrasena() async {
    String email = _emailController.text;

    try {
      bool isTokenValid = await authManager.isTokenValid();

      if (!isTokenValid) {
        await authManager.refreshAccessToken();
      }

      String? accessToken = authManager.accessToken;

      final response = await http.post(
        Uri.parse(
            'http://webapicuv.urvaseo.com:8081/wbsWebsisApp/api/Recupera_Contrasena/postall?AspxAutoDetectCookieSupport=1'),
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
        final Map<String, dynamic> responseData =
            responseJson[0] as Map<String, dynamic>;
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
            if (parsedJson.isNotEmpty &&
                parsedJson[0] is Map<String, dynamic>) {
              final Map<String, dynamic> responseData =
                  parsedJson[0] as Map<String, dynamic>;
              message = responseData['MENSSAGE']?.toString();
              result = responseData['RESULTADO']?.toString();
              if (result == 'OK') {
                MessageManager.showMessage(
                    context, 'Mensaje: $message', MessageType.success);
                await Future.delayed(Duration(seconds: 5));
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),);
              } else {
                MessageManager.showMessage(
                    context, 'Mensaje: $message', MessageType.error);
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
        print('Mensaje: $message');
      } else {
        print(
            'El campo MENSSAGE no está presente o es nulo en la respuesta del servidor');
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                color: Colors.lightBlue,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_open,
                      size: 80,
                      color: Colors.white,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Recuperar Contraseña',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                  border: OutlineInputBorder(),
                ),
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
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Recuperar Contraseña',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

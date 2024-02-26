import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../clases/auth_manager.dart';
import '../clases/message_manager.dart';
import 'login_screen.dart';

class RegistroUsuarioScreen extends StatefulWidget {
  @override
  _RegistroUsuarioScreenState createState() => _RegistroUsuarioScreenState();
}

class _RegistroUsuarioScreenState extends State<RegistroUsuarioScreen> {
  Auth_Manager authManager = Auth_Manager();

  TextEditingController _cedulaController = TextEditingController();
  TextEditingController _correoController = TextEditingController();

  Future<void> _registrarUsuario() async {
    String cedula = _cedulaController.text;
    String correo = _correoController.text;

    try {
      bool isTokenValid = await authManager.isTokenValid();

      if (!isTokenValid) {
        await authManager.refreshAccessToken();
      }

      String? accessToken = authManager.accessToken;

      final response = await http.post(
        Uri.parse('http://webapicuv.urvaseo.com:8081/wbsWebsisApp/api/Registro_usuario/postall?AspxAutoDetectCookieSupport=1'),
        body: jsonEncode({'_USUARIO': correo, '_CEDULA': cedula}),
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
          final Map<String, dynamic> responseData = parsedJson[0] as Map<String, dynamic>;
          message = responseData['MENSSAGE']?.toString();
          result = responseData['RESULTADO']?.toString();
          if (result == 'OK') {
            MessageManager.showMessage(context, 'Mensaje: $message', MessageType.success);
            await Future.delayed(Duration(seconds: 5));
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()),);
          } else {
            MessageManager.showMessage(context, 'Mensaje: $message', MessageType.error);
          }
        } catch (e) {
          print('Error al decodificar la cadena JSON: $e');
          MessageManager.showMessage(context, 'Mensaje: $e', MessageType.error);
          return;
        }
      } else {
        print('Tipo de respuesta inesperado: ${responseJson.runtimeType}');
        MessageManager.showMessage(context, 'Mensaje: ${responseJson.runtimeType}', MessageType.error);
        return;
      }
    } catch (e) {
      print('Error al realizar la solicitud HTTP: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Usuario'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                color: Colors.lightGreen,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_add_rounded,
                      size: 80,
                      color: Colors.white,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Registro de Nuevo Usuario',
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
                controller: _cedulaController,
                decoration: InputDecoration(
                  labelText: 'Cédula de Identidad',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _correoController,
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _registrarUsuario,
                child: Text('Registrar'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

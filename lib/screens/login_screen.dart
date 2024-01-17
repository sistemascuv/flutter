import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../clases/auth_manager.dart';
import '../clases/message_manager.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Auth_Manager authManager = Auth_Manager();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    try {
      bool isTokenValid = await authManager.isTokenValid();

      if (!isTokenValid) {
        await authManager.refreshAccessToken();
      }

      String? accessToken = authManager.accessToken;

      final response = await http.post(
        Uri.parse('http://cscsrv002.consorcio.com:8081/wbsWebsisApp/api/LoginWebsis/postall?AspxAutoDetectCookieSupport=1'),
        body: jsonEncode({'_EMPRESA': 45, '_USUARIO': username, '_PASS': password}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      final dynamic responseJson = jsonDecode(response.body);

      String? message;

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
          } else if (parsedJson is List) {
            if (parsedJson.isNotEmpty && parsedJson[0] is Map<String, dynamic>) {
              final Map<String, dynamic> responseData = parsedJson[0] as Map<String, dynamic>;
              message = responseData['MENSSAGE']?.toString();
              if (message=='OK'){
                MessageManager.showMessage(context, 'Mensaje: $message', MessageType.success);
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
        // Luego, puedes usar MessageManager.showMessage con el mensaje
        // MessageManager.showMessage(context, message, MessageType.success);
      } else {
        print('El campo MENSSAGE no está presente o es nulo en la respuesta del servidor');
      }



      if (message != null) {
        MessageManager.showMessage(context, 'Mensaje: $message', MessageType.success);
        print('Mensaje: $message');
      } else {
        print('La respuesta del servidor no contiene un mensaje esperado');
      }
    } catch (e) {
      print('Error al realizar la solicitud HTTP: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio de Sesión'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/urvaseo2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50.0,
                backgroundImage: AssetImage('assets/urvaseo.jpg'),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Usuario',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  primary: Colors.lightGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text('Iniciar Sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

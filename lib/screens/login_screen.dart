import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
//import '../Clases/auth_manager.dart';
import '../clases/auth_manager.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Auth_Manager authManager = Auth_Manager(); // AuthManager(); // Crear una instancia de AuthManager

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    try {
      // Verificar si el token es válido
      bool isTokenValid = await authManager.isTokenValid();

      // Si el token no es válido, renovarlo
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

      if (response.statusCode == 200) {
        // Resto de tu lógica...
        print('Éxito: ${response.body}');
      } else {
        // Manejo del error de autenticación
        print('Error de autenticación: ${response.statusCode}');
      }
    } catch (e) {
      // Manejo de otros errores, como problemas de conexión, etc.
      print('Error al realizar la solicitud HTTP: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error de autenticación'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
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
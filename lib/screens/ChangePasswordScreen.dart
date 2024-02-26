import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../clases/auth_manager.dart';
import '../clases/message_manager.dart';
import 'login_screen.dart';
import 'theme_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  String? _userEmail;
  bool _passwordsMatch = false;
  Auth_Manager authManager = Auth_Manager();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Cambio de Contraseña'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cambie su Contraseña',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _currentPasswordController,
              decoration: InputDecoration(
                labelText: 'Contraseña Actual',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _newPasswordController,
              onChanged: (_) => _verifyPasswords(),
              decoration: InputDecoration(
                labelText: 'Nueva Contraseña',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _confirmPasswordController,
              onChanged: (_) => _verifyPasswords(),
              decoration: InputDecoration(
                labelText: 'Confirme Nueva Contraseña',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _passwordsMatch ? _cambiaContrasena : null,
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Text(
                  'Cambio de Contraseña',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _verifyPasswords() {
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;
    setState(() {
      _passwordsMatch = newPassword == confirmPassword;
    });
  }


  void _cambiaContrasena() async {
    String lcActual = _currentPasswordController.text;
    String lcNuevo = _newPasswordController.text;
    String lcConfirmar = _confirmPasswordController.text;

    try {
      bool isTokenValid = await authManager.isTokenValid();
      if (!isTokenValid) {
        await authManager.refreshAccessToken();
      }
      String? accessToken = authManager.accessToken;

      final response = await http.post(
        Uri.parse('http://webapicuv.urvaseo.com:8081/wbsWebsisApp/api/Cambia_Contrasena/postall?AspxAutoDetectCookieSupport=1'),
        body: jsonEncode({
          '_CORREO': _userEmail,
          '_EMPRESA': 45,
          '_PASS': lcActual,
          '_PASS_NUEVO': lcNuevo,
          '_PASS_VERIF': lcConfirmar,
        }),
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

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userEmail = prefs.getString('correo');
    setState(() {});
  }
}

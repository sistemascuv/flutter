import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../clases/auth_manager.dart';
import '../clases/message_manager.dart';
import '../clases/user_data.dart';
import 'HomeScreen.dart';
import 'recuperar_contrasena.dart';
import 'registro_usuario.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Auth_Manager authManager = Auth_Manager();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

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
        Uri.parse(
            'http://webapicuv.urvaseo.com:8081/wbsWebsisApp/api/LoginWebsis/postall?AspxAutoDetectCookieSupport=1'),
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
              if (message == 'OK') {
                UserData.NombreUsuario = responseData['NOMCOMPLETO']?.toString() ?? '';
                UserData.codigo = responseData['CODIGO']?.toString() ?? '';
                UserData.cedula = responseData['CEDULA']?.toString() ?? '';
                UserData.correo = responseData['CORREO']?.toString() ?? '';
                UserData.cargo = responseData['CARGO']?.toString() ?? '';
                UserData.video = 'SI';

                UserData.fotousuario = await _saveImageLocally(responseData['FOTOBYTE']?.toString() ?? '');

                await saveToGallery(base64.decode(responseData['FOTOBYTE']?.toString() ?? ''));
                await _saveUserData();
                await _saveSessionState(username);
                _navigateToHomeScreen();
               // MessageManager.showMessage(context, 'Registro realizado con éxito', MessageType.success);
              } else {
                MessageManager.showMessage(context, 'Mensaje: $message', MessageType.error);
              }
            } else {
               MessageManager.showMessage(context, 'Mensaje: $message', MessageType.error);
              print('La respuesta del servidor no es un formato JSON esperado');
              return;
            }
          } else {
             MessageManager.showMessage(context, 'Mensaje: $message', MessageType.error);
            print('La respuesta del servidor no es un formato JSON esperado');
            return;
          }
        } catch (e) {
           MessageManager.showMessage(context, 'Mensaje: $message', MessageType.error);
          print('Error al decodificar la cadena JSON: $e');
          return;
        }
      } else {
         MessageManager.showMessage(context, 'Mensaje: $message', MessageType.error);
        print('Tipo de respuesta inesperado: ${responseJson.runtimeType}');
        return;
      }
    } catch (e) {
       MessageManager.showMessage(context, 'Mensaje: $e', MessageType.error);
      print('Error al realizar la solicitud HTTP: $e');
    }
  }

  Future<String> _saveImageLocally(String imageBytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/profile_image.jpg';

    final Uint8List bytes = base64.decode(imageBytes);
    await File(imagePath).writeAsBytes(bytes);
    return imagePath;
  }

  Future<void> _saveSessionState(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }

  Future<void> _saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('nombreUsuario', UserData.NombreUsuario);
    prefs.setString('codigo', UserData.codigo);
    prefs.setString('cedula', UserData.cedula);
    prefs.setString('correo', UserData.correo);
    prefs.setString('cargo', UserData.cargo);
    prefs.setString('video', UserData.video);
  }

  Future<void> saveToGallery(Uint8List imageData) async {
    try {
      final result = await ImageGallerySaver.saveImage(imageData);
      print('Guardado en la galería: $result');
    } catch (e) {
      print('Error al guardar en la galería: $e');
    }
  }

  Future<void> _checkSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString('username');

    if (savedUsername != null && savedUsername.isNotEmpty) {
      UserData.NombreUsuario = prefs.getString('nombreUsuario') ?? '';
      UserData.codigo = prefs.getString('codigo') ?? '';

      _navigateToHomeScreen();
    }
  }

  void _navigateToHomeScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
    );
  }

  void _irARegistroUsuario(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistroUsuarioScreen()),
    );
  }

  void _irARecuperarContrasena(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecuperarContrasenaScreen()),
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 80.0,
                  backgroundImage: AssetImage('assets/URVASEO LOGO.png'),
                ),
                SizedBox(height: 20.0),
                TextField(
  controller: _usernameController,
  style: TextStyle(color: const Color.fromARGB(255, 11, 11, 11)),
  decoration: InputDecoration(
    labelText: 'Correo',
    labelStyle: TextStyle(color: const Color.fromARGB(255, 18, 18, 18)),
    filled: true,
    fillColor: Colors.lightGreen.withOpacity(0.5),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide.none,
    ),
    prefixIcon: Icon(Icons.person, color: const Color.fromARGB(255, 3, 3, 3)),
  ),
),
SizedBox(height: 16.0),
TextField(
  controller: _passwordController,
  style: TextStyle(color: Color.fromARGB(255, 10, 10, 10)),
  obscureText: true,
  decoration: InputDecoration(
    labelText: 'Contraseña',
    labelStyle: TextStyle(color: Color.fromARGB(255, 2, 2, 2)),
    filled: true,
    fillColor: Colors.lightGreen.withOpacity(0.5),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide.none,
    ),
    prefixIcon: Icon(Icons.lock, color: const Color.fromARGB(255, 16, 15, 15)),
  ),
),

                SizedBox(height: 16.0),
                TextButton(
                  onPressed: () => _irARegistroUsuario(context),
                  child: Text(
                    'Registrarse',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
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
                TextButton(
                  onPressed: () => _irARecuperarContrasena(context),
                  child: Text(
                    'Recuperar Contraseña',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

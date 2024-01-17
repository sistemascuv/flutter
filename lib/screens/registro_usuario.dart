// registro_usuario.dart

import 'package:flutter/material.dart';

class RegistroUsuarioScreen extends StatefulWidget {
  @override
  _RegistroUsuarioScreenState createState() => _RegistroUsuarioScreenState();
}

class _RegistroUsuarioScreenState extends State<RegistroUsuarioScreen> {
  TextEditingController _cedulaController = TextEditingController();
  TextEditingController _correoController = TextEditingController();

  void _registrarUsuario() {
    // Implementa la lógica de registro aquí
    // Puedes enviar los datos al servidor, mostrar mensajes, etc.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Usuario'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _cedulaController,
              decoration: InputDecoration(labelText: 'Cédula de Identidad'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _correoController,
              decoration: InputDecoration(labelText: 'Correo Electrónico'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _registrarUsuario,
              child: Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}

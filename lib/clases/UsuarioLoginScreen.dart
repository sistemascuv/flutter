import 'package:flutter/material.dart';

class UsuarioLoginScreen extends StatelessWidget {
  final String nombre;
  final String email;

  UsuarioLoginScreen({required this.nombre, required this.email});

  @override
  Widget build(BuildContext context) {
    // Aquí puedes devolver un widget que represente la información del usuario.
    // Por ejemplo, puedes usar un ListTile.
    return ListTile(
      title: Text('Nombre: $nombre'),
      subtitle: Text('Email: $email'),
    );
  }
}

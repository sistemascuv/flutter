// menu.dart
import 'package:flutter/material.dart';
import '../clases/message_manager.dart';
//import 'login_screen.dart';


class menu extends StatelessWidget {
  const menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú Principal'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Cambio de Ontraseña 1'),
            onTap: () {
              Navigator.pop(context); // Cierra el Drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Opcion1Screen(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Opción 2'),
            onTap: () {
              Navigator.pop(context); // Cierra el Drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Opcion2Screen(),
                ),
              );
            },
          ),
          // Añade más opciones según sea necesario
        ],
      ),
    );
  }
}

class Opcion1Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opción 1'),
      ),
      body: const Center(
        child: Text('Contenido de la Opción 1'),
      ),
    );
  }
}

class Opcion2Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opción 2'),
      ),
      body: const Center(
        child: Text('Contenido de la Opción 2'),
      ),
    );
  }
}

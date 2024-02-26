import 'package:flutter/material.dart';
import '../clases/menu.dart';
import '../clases/UsuarioLoginScreen.dart';


class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Agregar lógica para abrir la pantalla de búsqueda
            },
          ),
          IconButton(
            icon: Icon(Icons.message),
            onPressed: () {
              // Agregar lógica para abrir la pantalla de mensajes
            },
          ),
        ],
      ),
      drawer: menu(),
      body: Center(
        child: Text('Contenido de la Página Principal'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Amigos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notificaciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Más',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Color.fromARGB(255, 71, 121, 39),
        onTap: (index) {
          // Agregar lógica para cambiar de pantalla según el índice seleccionado
          // Ejemplo: Navigator.pushNamed(context, '/pagina_$index');
        },
      ),
    );
  }
}

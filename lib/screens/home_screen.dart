import 'package:flutter/material.dart';

class home_screen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<home_screen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Usuario'),
              accountEmail: Text('usuario@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Inicio'),
              onTap: () {
                // Lógica para ir a la pantalla de inicio (actual)
                Navigator.pop(context);
                _onMenuItemSelected(0);
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Perfil'),
              onTap: () {
                // Lógica para ir a la pantalla de perfil
                Navigator.pop(context);
                _onMenuItemSelected(1);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configuración'),
              onTap: () {
                // Lógica para ir a la pantalla de configuración
                Navigator.pop(context);
                _onMenuItemSelected(2);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          'Contenido de la pantalla principal',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onMenuItemSelected,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Amigos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Mensajes',
          ),
        ],
      ),
    );
  }

  void _onMenuItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
      // Lógica para mostrar la pantalla de inicio
        break;
      case 1:
      // Lógica para mostrar la pantalla de amigos
        break;
      case 2:
      // Lógica para mostrar la pantalla de mensajes
        break;
    // Agrega más casos según sea necesario
    }
  }
}

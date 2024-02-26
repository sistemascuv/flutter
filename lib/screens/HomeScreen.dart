import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../clases/user_data.dart';
import 'login_screen.dart';
import 'SolicitudConsultaScreen.dart'; // Importar la nueva pantalla
import 'ChangePasswordScreen.dart';
import 'theme_screen.dart'; // Importar la nueva pantalla para el cambio de tema

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isLoading = false; // Variable para indicar si se está cargando

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: Drawer(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Theme(
            data: Theme.of(context).copyWith(
              iconTheme: IconThemeData(
                color: Theme.of(context).textTheme.bodyText1?.color,
              ),
            ),
            child: ListView(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(
                    UserData.NombreUsuario,
                    style: TextStyle(color: Theme.of(context).textTheme.bodyText1?.color),
                  ),
                  accountEmail: Text(
                    UserData.correo,
                    style: TextStyle(color: Theme.of(context).textTheme.bodyText1?.color),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Theme.of(context).backgroundColor,
                    child: CachedNetworkImage(
                      imageUrl: UserData.fotousuario,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Inicio'),
                  onTap: () {
                    Navigator.pop(context);
                    _onDrawerItemSelected(0);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Perfil'),
                  onTap: () {
                    Navigator.pop(context);
                    _onDrawerItemSelected(1);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.password),
                  title: Text('Cambio de Contraseña'),
                  onTap: () {
                    Navigator.pop(context);
                    _navigateToChangePasswordScreenState();
                  },
                ),
                ListTile( // Nueva opción para la solicitud de consulta dental
                  leading: Icon(Icons.medical_services),
                  title: Text('Solicitud de Consulta Dental'),
                  onTap: () {
                    Navigator.pop(context);
                    _navigateToSolicitudConsultaScreen();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.color_lens), // Icono para cambiar el tema
                  title: Text('Cambiar Tema'), // Texto para cambiar el tema
                  onTap: () {
                    Navigator.pop(context);
                    _navigateToThemeScreen(); // Navegar a la pantalla de cambio de tema
                  },
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Salir'),
                  onTap: () async {
                    await _logout();
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: _isLoading // Muestra el indicador de carga si _isLoading es true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Text(
                'URVASEO',
                style: TextStyle(fontSize: 24.0),
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavBarItemSelected,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help_center),
            label: 'Ayuda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Mensajes',
          ),
        ],
      ),
    );
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserData.NombreUsuario = prefs.getString('nombreUsuario') ?? '';
    UserData.codigo = prefs.getString('codigo') ?? '';
    UserData.cedula = prefs.getString('cedula') ?? '';
    UserData.correo = prefs.getString('correo') ?? '';
    UserData.cargo = prefs.getString('cargo') ?? '';
    UserData.video = prefs.getString('video') ?? '';
  }

  void _onDrawerItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Lógica para mostrar la pantalla de inicio
        break;
      case 1:
        // Lógica para mostrar la pantalla de perfil
        break;
      case 2:
        // Lógica para mostrar la pantalla de configuración
        break;
    }
  }

  void _onBottomNavBarItemSelected(int index) {
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
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('username');
    if (UserData.video == 'NO') {
      prefs.remove('videoPlayed');
    }
  }

  void _navigateToSolicitudConsultaScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SolicitudConsultaScreen()),
    );
  }

    void  _navigateToChangePasswordScreenState() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  ChangePasswordScreen()),
    );
  }

  void _navigateToThemeScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ThemeScreen()),
    );
  }
}

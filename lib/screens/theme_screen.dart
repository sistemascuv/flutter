import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../clases/theme_provider.dart';

class ThemeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Theme Settings'),
        backgroundColor: Colors.green, // Color primario del tema
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Change Theme',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
              },
              child: Text('Toggle Theme'),
            ),
          ],
        ),
      ),
    );
  }
}

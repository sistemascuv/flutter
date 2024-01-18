import 'package:flutter/material.dart';

class MessageManager {
  static void showMessage(BuildContext context, String message, MessageType type) {
    IconData icon;
    Color backgroundColor;

    switch (type) {
      case MessageType.success:
        icon = Icons.check_circle;
        backgroundColor = Colors.green;
        break;
      case MessageType.warning:
        icon = Icons.warning;
        backgroundColor = Colors.amber;
        break;
      case MessageType.error:
        icon = Icons.error;
        backgroundColor = Colors.red;
        break;
      case MessageType.info:
        icon = Icons.info;
        backgroundColor = Colors.blue;
        break;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              Icon(icon, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                child: Text(message, style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          backgroundColor: backgroundColor,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el AlertDialog
              },
              child: Text(
                'Aceptar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}

enum MessageType {
  success,
  warning,
  error,
  info,
}

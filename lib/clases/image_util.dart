import 'dart:typed_data';
import 'dart:convert'; // Asegúrate de importar esta línea para 'base64'
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ImageUtil {
  static Future<String> saveImageLocally(String base64Image) async {
    try {
      Uint8List bytes = base64.decode(base64Image);
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;

      File file = File('$appDocPath/profile_image.jpg');
      await file.writeAsBytes(bytes);

      return file.path;
    } catch (e) {
      print('Error al guardar la imagen localmente: $e');
      return '';
    }
  }
}

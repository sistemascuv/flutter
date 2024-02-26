import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../clases/auth_manager.dart';
import '../clases/message_manager.dart';
import '../clases/user_data.dart';
import 'package:url_launcher/url_launcher.dart';

class SolicitudConsultaScreen extends StatefulWidget {
  @override
  _SolicitudConsultaScreenState createState() => _SolicitudConsultaScreenState();
}

class _SolicitudConsultaScreenState extends State<SolicitudConsultaScreen> {
  Auth_Manager authManager = Auth_Manager();
  List<Map<String, dynamic>> solicitudes = [];
  List<Map<String, dynamic>> ListaSol = [];
  String? _selectedDependienteCodigo;
  bool _paraMiSelected = false;
  bool _isLoading = false;


  @override
  void initState() {
    super.initState();
    _fetchDependientes();
    _fetchSolicitudes();
  }

  Future<void> _fetchSolicitudes() async {
 setState(() {
    _isLoading = true;
  });


    try {
      bool isTokenValid = await authManager.isTokenValid();

      if (!isTokenValid) {
        await authManager.refreshAccessToken();
      }

      String? accessToken = authManager.accessToken;
      int LNCODIGO = double.tryParse(UserData.codigo ?? '')?.truncate()?.toInt() ?? 0;

      final response = await http.post(
        Uri.parse('http://webapicuv.urvaseo.com:8081/wbsWebsisApp/api/ConSolOdont/postall?AspxAutoDetectCookieSupport=1'),
        body: jsonEncode({'_CODIGO': LNCODIGO, '_EMPRESA': 45}),
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
               // Esta parte para llenar la lista de Solicitudes

                setState(() {
                  ListaSol = List<Map<String, dynamic>>.from(parsedJson);
                    _isLoading = false;
                });


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


Future<void> _fetchDependientes() async {
    try {
      bool isTokenValid = await authManager.isTokenValid();

      if (!isTokenValid) {
        await authManager.refreshAccessToken();
      }

      String? accessToken = authManager.accessToken;
      int LNCODIGO = double.tryParse(UserData.codigo ?? '')?.truncate()?.toInt() ?? 0;

      final response = await http.post(
        Uri.parse('http://webapicuv.urvaseo.com:8081/wbsWebsisApp/api/SolConDental/postall?AspxAutoDetectCookieSupport=1'),
        body: jsonEncode({'_CODIGO': LNCODIGO, '_EMPRESA': 45}),
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
                setState(() {
                  solicitudes = List<Map<String, dynamic>>.from(parsedJson);
                });
                //print(solicitudes);

                //MessageManager.showMessage(context, 'Registro realizado con éxito', MessageType.success);
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


  Future<void> _guardarSolicitud() async {
    // Implementa la lógica para guardar la solicitud y manejarla según el dependiente seleccionado
  try {
      bool isTokenValid = await authManager.isTokenValid();

      if (!isTokenValid) {
        await authManager.refreshAccessToken();
      }

      String? accessToken = authManager.accessToken;
      int LNCODIGO = double.tryParse(UserData.codigo ?? '')?.truncate()?.toInt() ?? 0;
      int LnDependiente = double.tryParse(_selectedDependienteCodigo ?? '')?.truncate()?.toInt() ?? 0;
      String? Lcparami="NO" ;

        if (_paraMiSelected) {
                Lcparami="SI";
         }

      final response = await http.post(
        Uri.parse('http://webapicuv.urvaseo.com:8081/wbsWebsisApp/api/GuardaOrden/postall?AspxAutoDetectCookieSupport=1'),
        body: jsonEncode({'_CODIGO': LNCODIGO, '_EMPRESA': 45,'_DEPENDIENTE':LnDependiente,'_PARAMI':Lcparami  }),
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
                _fetchSolicitudes();

                MessageManager.showMessage(context, 'Registro realizado con éxito', MessageType.success);
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






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green, // Color de fondo de la franja
        title: Row(
          children: [
            Icon(Icons.description), // Icono de documento
            SizedBox(width: 10),
            Text(
              'Orden Odontológica',
              style: TextStyle(color: Colors.white), // Color del texto del título
            ),
          ],
        ),
        elevation: 0, // Elimina la sombra debajo del appBar
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(10.0), // Altura de la franja
          child: Container(
            color: Colors.grey, // Color de la franja
            height: 10.0, // Altura de la franja
          ),
        ),
      ),
      body:_isLoading // Muestra el indicador de carga si _isLoading es true
          ? Center(child: CircularProgressIndicator())
      :Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Datos del Empleado:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyText1?.color),
            ),
            SizedBox(height: 10),
            // Muestra los datos del empleado
            _buildEmpleadoInfo(),
            SizedBox(height: 20),
            Text(
              'Dependientes:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyText1?.color),
            ),
            SizedBox(height: 10),
            // ComboBox para seleccionar dependientes
            _buildDependienteDropdown(),
            SizedBox(height: 20),
            // Checkbox para seleccionar "Para mí"
            _buildParaMiCheckbox(),
            SizedBox(height: 20),
            Text(
              'Lista de Ordenes Odontológicas:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyText1?.color),
            ),
            SizedBox(height: 10),
            // Lista de solicitudes
            Expanded(
              child: _buildSolicitudesList(),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (_selectedDependienteCodigo != null || _paraMiSelected) {
                    bool? confirmacion = await showDialog<bool?>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Confirmación'),
                        content: Text(
                            '¿Está seguro de guardar la Orden${_paraMiSelected ? " para usted" : " para el dependiente seleccionado"}?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text('Guardar'),
                          ),
                        ],
                      ),
                    );

                    if (confirmacion != null && confirmacion) {
                      await _guardarSolicitud();
                    }
                  } else {
                    // Mostrar mensaje de selección de dependiente
                    MessageManager.showMessage(context, 'Debe seleccionar un dependiente o elegir "Para mí"', MessageType.error);
                  }
                },
                child: Text('Guardar Orden'),
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildEmpleadoInfo() {
  return Card(
    elevation: 4,
    margin: EdgeInsets.only(top: 10),
    color: Theme.of(context).cardColor, // Utilizar el color de fondo del tema actual
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nombre:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyText1?.color, // Color del texto
            ),
          ),
          SizedBox(height: 5),
          Text(
            UserData.NombreUsuario,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodyText1?.color,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Cargo:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyText1?.color,
            ),
          ),
          SizedBox(height: 5),
          Text(
            UserData.cargo,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodyText1?.color,
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildDependienteDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedDependienteCodigo,
      onChanged: (String? newValue) {
        setState(() {
          _selectedDependienteCodigo = newValue;
          _paraMiSelected = false; // Desactivar la opción "Para mí"
        });
      },
      elevation: 4,
      decoration: InputDecoration(
        labelText: 'Seleccionar Dependiente',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      itemHeight: 60, // Ajusta la altura de cada elemento del menú desplegable
      selectedItemBuilder: (BuildContext context) {
        return solicitudes.map<Widget>((solicitud) {
          return Container(
            alignment: Alignment.center,
            height: 60,
            child: Text(
              solicitud['NOMBRE'].toString(),
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyText1?.color,
                fontSize: 12, // Reduce el tamaño de fuente
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
                letterSpacing: 0.5,
              ),
            ),
          );
        }).toList();
      },
      items: solicitudes.map<DropdownMenuItem<String>>((solicitud) {
        return DropdownMenuItem<String>(
          value: solicitud['COD_DEPENDIENTE'].toString(),
          child: Text(
            solicitud['NOMBRE'].toString(),
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyText1?.color,
              fontSize: 14, // Reduce el tamaño de fuente
              fontWeight: FontWeight.w500,
              fontFamily: 'Roboto',
              letterSpacing: 0.5,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildParaMiCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _paraMiSelected,
          onChanged: (bool? newValue) {
            setState(() {
              _paraMiSelected = newValue ?? false;
              if (_paraMiSelected) {
                _selectedDependienteCodigo = null; // Deseleccionar dependiente si está seleccionada la opción "Para mí"
              }
            });
          },
        ),
        Text(
          'Para mí',
          style: TextStyle(
            fontSize: 16, // Reduce el tamaño de fuente
            color: Theme.of(context).textTheme.bodyText1?.color,
          ),
        ),
      ],
    );
  }

// Función para lanzar el enlace
launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'No se pudo abrir el enlace $url';
  }
}


  Widget _buildSolicitudesList() {
    return ListView.builder(
      itemCount: ListaSol.length,
      itemBuilder: (context, index) {
        var solicitud = ListaSol[index];
        var numeroSolicitud = solicitud['ID'];
        var nombreDependiente = solicitud['NOMBRE'];
        var fecha = solicitud['FECHA_CRE'];

        return Card(
          elevation: 4,
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Número de Solicitud: $numeroSolicitud',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyText1?.color),
                ),
                Text(
                  'Dependiente: $nombreDependiente',
                  style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodyText1?.color),
                ),
                Text(
                  'Fecha: $fecha',
                  style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodyText1?.color),
                ),
              ],
            ),
           /*  trailing: ElevatedButton(
              onPressed: () {

           Uri url = Uri.parse('http://portal.urvaseo.com/ibmcognos/cgi-bin/cognosisapi.dll?b_action=cognosViewer&ui.action=run&ui.object=%2fcontent%2ffolder%5b%40name%3d%27App%27%5d%2freport%5b%40name%3d%27OrdenOdontologica%27%5d&ui.name=OrdenOdontologica&run.outputFormat=&run.prompt=true&CAMUsername=M.MACHADO&CAMPassword=Manu2024.&p_P_empresa=45&p_P_PACIENTE=57192&p_P_EMPLEADO=234696&run.prompt=false');

               // String url = 'http://portal.urvaseo.com/ibmcognos/cgi-bin/cognosisapi.dll?b_action=cognosViewer&ui.action=run&ui.object=%2fcontent%2ffolder%5b%40name%3d%27App%27%5d%2freport%5b%40name%3d%27OrdenOdontologica%27%5d&ui.name=OrdenOdontologica&run.outputFormat=&run.prompt=true&CAMUsername=M.MACHADO&CAMPassword=Manu2024.&p_P_empresa=45&p_P_PACIENTE=57192&p_P_EMPLEADO=234696&run.prompt=false';

                launchURL(url);

                // Lógica para iMPRIMIR  la solicitud
              },
              child: Text(
                'Imprimir Orden',
                style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.bodyText1?.color),
              ),
            ), */
          ),
        );
      },
    );
  }
}

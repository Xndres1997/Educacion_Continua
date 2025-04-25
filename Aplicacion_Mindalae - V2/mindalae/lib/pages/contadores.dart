import 'package:flutter/material.dart';
import 'package:mindalae/connection_service.dart'; // Ajusta el path
import 'package:intl/intl.dart';

class ContadoresScreen extends StatefulWidget {
  const ContadoresScreen({super.key});

  @override
  State<ContadoresScreen> createState() => _ContadoresScreenState();
}

class _ContadoresScreenState extends State<ContadoresScreen> {
  final ConnectionService _connectionService = ConnectionService();
  late Future<int>
  _contadorActual; // Para obtener el contador de conexiones mensuales
  late Stream<int>
  _contadorEnTiempoReal; // Para obtener el contador de usuarios activos

  @override
  void initState() {
    super.initState();
    // Obtener el mes actual para el contador mensual
    String mesActual = DateFormat('yyyy-MM').format(DateTime.now());
    _contadorActual = _connectionService.obtenerContadorPorMes(mesActual);

    // Establecer el stream para obtener el contador en tiempo real
    _contadorEnTiempoReal =
        _connectionService.obtenerContadorUsuariosEnTiempoReal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contadores de Usuarios"),
        backgroundColor: const Color.fromRGBO(157, 157, 156, 1),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Contador de usuarios conectados en tiempo real
            StreamBuilder<int>(
              stream: _contadorEnTiempoReal,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (!snapshot.hasData || snapshot.data == 0) {
                  return const Text(
                    'No hay usuarios conectados en este momento.',
                    style: TextStyle(fontSize: 20),
                  );
                } else {
                  return Text(
                    'Usuarios conectados en tiempo real: ${snapshot.data}',
                    style: const TextStyle(fontSize: 20),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            // Contador de usuarios conectados este mes
            FutureBuilder<int>(
              future: _contadorActual,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}"); // Manejo de errores
                } else if (!snapshot.hasData || snapshot.data == 0) {
                  return const Text(
                    'No hay usuarios conectados este mes.',
                    style: TextStyle(fontSize: 20),
                  );
                } else {
                  return Text(
                    'Usuarios conectados este mes: ${snapshot.data}',
                    style: const TextStyle(fontSize: 20),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

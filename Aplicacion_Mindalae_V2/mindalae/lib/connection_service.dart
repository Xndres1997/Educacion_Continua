import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class ConnectionService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // Método para registrar la conexión del usuario
  Future<void> registrarConexion() async {
    final user = _auth.currentUser;
    if (user != null) {
      final uid = user.uid;
      final now = DateTime.now();
      final monthYear = DateFormat('yyyy-MM').format(now);

      // 1. Incrementar contador de conexiones del mes
      final connRef = _database
          .ref("userStats")
          .child(monthYear)
          .child(uid)
          .child("connections");
      final snapshot = await connRef.get();
      final conexiones = (snapshot.value as int?) ?? 0;
      await connRef.set(conexiones + 1);

      // 2. Registrar en usuarios activos
      await _database.ref("activeUsers").child(uid).set(true);
    }
  }

  // Método para eliminar la conexión del usuario
  Future<void> eliminarConexion() async {
    final user = _auth.currentUser;
    if (user != null) {
      final uid = user.uid;
      // Solo eliminamos de los activos
      await _database.ref("activeUsers").child(uid).remove();
    }
  }

  // Método para obtener el contador de usuarios conectados en tiempo real
  Stream<int> obtenerContadorUsuariosEnTiempoReal() {
    final dbRef = _database.ref().child("activeUsers");

    return dbRef.onValue.map((event) {
      final data = event.snapshot.value as Map?;
      return data?.length ?? 0;
    });
  }

  // Método para obtener el total de conexiones del mes (sumando todos los usuarios)
  Future<int> obtenerContadorPorMes(String monthYear) async {
    final dbRef = _database.ref().child("userStats").child(monthYear);
    final snapshot = await dbRef.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map?;
      int total = 0;

      data?.forEach((key, value) {
        if (value is Map && value['connections'] is int) {
          total +=
              value['connections']
                  as int; // Sumar las conexiones de cada usuario
        }
      });

      return total;
    }
    return 0;
  }
}

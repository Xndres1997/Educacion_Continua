import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mindalae/connection_service.dart';
import 'package:mindalae/pages/contadores.dart';

class MenuLateral extends StatelessWidget {
  final Function(int)? onItemSelected;
  final VoidCallback onToggleTheme;

  const MenuLateral({
    super.key,
    this.onItemSelected,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(
        0,
        165,
        165,
        165,
      ), // fondo transparente
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(
            0,
            0,
            0,
            0,
          ).withOpacity(0.7), // 0.0 = totalmente transparente, 1.0 = opaco
          // Fondo translúcido
        ),
        child: Column(
          children: [
            // Encabezado del Drawer
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50), // Espacio superior
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/logo1.png', // Ruta de tu imagen
                        width: 60,
                        height: 60,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 40),
                      const Text(
                        'MINDALAE',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(color: Colors.white54),
            // Menú de navegación
            ListTile(
              leading: const Icon(Icons.home, color: Colors.white),
              title: const Text('Home', style: TextStyle(color: Colors.white)),
              onTap: () {
                onItemSelected?.call(0);
                Navigator.pop(context);
              },
            ),
            StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active &&
                    snapshot.hasData) {
                  final user = snapshot.data;
                  final isAdmin =
                      user?.uid ==
                      "Vj4JqSnU0xQRgUPIq1RMgS8rued2"; // 👈 tu UID real

                  if (isAdmin) {
                    return ListTile(
                      leading: const Icon(Icons.bar_chart, color: Colors.white),
                      title: const Text(
                        'Contadores',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.pop(context); // Cierra el drawer
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ContadoresScreen(),
                          ), // Navega a la página de contadores
                        );
                      },
                    );
                  }
                }
                return const SizedBox.shrink(); // No muestra nada si no es admin
              },
            ),

            // Opción para cambiar el tema
            /*ListTile(
              leading: const Icon(Icons.brightness_6),
              title: const Text("Cambiar tema"),
              onTap: () {
                Navigator.pop(context); // Cierra el drawer
                onToggleTheme(); // Llama a la función que cambia el tema
              },
            ),*/

            // Redes sociales y enlaces
            ListTile(
              leading: const Icon(Icons.facebook, color: Colors.white),
              title: const Text(
                'Facebook',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                const url = 'https://www.facebook.com/mindalaeupecc';
                try {
                  await launch(url);
                } catch (e) {
                  print('Error al intentar abrir la URL: $e');
                }
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.travel_explore_outlined,
                color: Colors.white,
              ),
              title: const Text(
                'Página Web',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                const url = 'https://mindalae.upec.edu.ec/';
                try {
                  await launch(url);
                } catch (e) {
                  print('Error al intentar abrir la URL: $e');
                }
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.youtube_searched_for,
                color: Colors.white,
              ),
              title: const Text(
                'Youtube',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                const url = 'https://www.youtube.com/@mindalaeupec';
                try {
                  await launch(url);
                } catch (e) {
                  print('Error al intentar abrir la URL: $e');
                }
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.tiktok, color: Colors.white),
              title: const Text(
                'Tiktok',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                const url = 'https://www.tiktok.com/@mindalaeupec';
                try {
                  await launch(url);
                } catch (e) {
                  print('Error al intentar abrir la URL: $e');
                }
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.comment, color: Colors.white),
              title: const Text(
                'Enviar Comentario',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {},
            ),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.white),
              title: const Text(
                'Acerca de',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {},
            ),
            ListTile(
              leading: const Icon(Icons.share, color: Colors.white),
              title: const Text(
                'Compartir APP',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {},
            ),
            ListTile(
              leading: const Icon(Icons.star_border, color: Colors.white),
              title: const Text(
                'Calificar APP',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {},
            ),
            ListTile(
              leading: const Icon(Icons.back_hand, color: Colors.white),
              title: const Text('Salir', style: TextStyle(color: Colors.white)),
              onTap: () async {},
            ),

            // Usamos un StreamBuilder para escuchar el estado de autenticación
            StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                print('Estado de autenticación: ${snapshot.connectionState}');
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasData) {
                  print('Usuario autenticado');
                  return ListTile(
                    leading: const Icon(Icons.exit_to_app, color: Colors.white),
                    title: const Text(
                      'Cerrar sesión',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () async {
                      final connectionService = ConnectionService();
                      await connectionService
                          .eliminarConexion(); // 👈 Elimina la conexión
                      await GoogleSignIn().signOut();
                      await FirebaseAuth.instance.signOut();
                      Navigator.pop(context);
                    },
                  );
                } else {
                  print('No hay usuario autenticado');
                  return const SizedBox.shrink(); // No muestra nada si no hay usuario
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

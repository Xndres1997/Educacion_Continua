import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
      backgroundColor: const Color.fromARGB(0, 165, 165, 165), // ← importante
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(1), // ← aquí el fondo translúcido
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.start, // Mueve el contenido hacia abajo
                crossAxisAlignment:
                    CrossAxisAlignment
                        .center, // Centra el contenido horizontalmente
                children: [
                  const SizedBox(
                    height: 50,
                  ), // Agrega espacio arriba para mover el contenido más abajo
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .start, // Centra la imagen y el texto horizontalmente
                    children: [
                      Image.asset(
                        'assets/logo1.png', // Ruta de tu imagen
                        width: 60, // Controla el tamaño de la imagen
                        height: 60, // Controla el tamaño de la imagen
                        fit:
                            BoxFit
                                .contain, // Asegura que la imagen no se distorsione
                      ),
                      const SizedBox(
                        width: 40,
                      ), // Espacio entre la imagen y el texto
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
            ListTile(
              leading: const Icon(Icons.home, color: Colors.white),
              title: const Text('Home', style: TextStyle(color: Colors.white)),
              onTap: () {
                onItemSelected?.call(0);
                Navigator.pop(context);
              },
            ),
            /*ListTile(
              leading: const Icon(Icons.tv, color: Colors.white),
              title: const Text('TV', style: TextStyle(color: Colors.white)),
              onTap: () {
                onItemSelected?.call(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.library_books, color: Colors.white),
              title: const Text(
                'Programas',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                onItemSelected?.call(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.login, color: Colors.white),
              title: const Text('Login', style: TextStyle(color: Colors.white)),
              onTap: () {
                onItemSelected?.call(3);
                Navigator.pop(context);
              },
            ),*/
            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: const Text("Cambiar tema"),
              onTap: () {
                Navigator.pop(context); // Cierra el drawer
                onToggleTheme(); // Llama a la función que cambia el tema
              },
            ),
            ListTile(
              leading: const Icon(Icons.facebook, color: Colors.white),
              title: const Text(
                'Facebook',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                const url =
                    'https://www.facebook.com/mindalaeupecc'; // URL que deseas abrir
                try {
                  await launch(url); // Intenta abrir la URL directamente
                } catch (e) {
                  print('Error al intentar abrir la URL: $e');
                }
                Navigator.pop(context);
              },
            ),
            //Botones Redes Sociales
            // FACEBOOK
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
                const url =
                    'https://mindalae.upec.edu.ec/'; // URL que deseas abrir
                try {
                  await launch(url); // Intenta abrir la URL directamente
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
                const url =
                    'https://www.youtube.com/@mindalaeupec'; // URL que deseas abrir
                try {
                  await launch(url); // Intenta abrir la URL directamente
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
                const url =
                    'https://www.tiktok.com/@mindalaeupec'; // URL que deseas abrir
                try {
                  await launch(url); // Intenta abrir la URL directamente
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
          ],
        ),
      ),
    );
  }
}

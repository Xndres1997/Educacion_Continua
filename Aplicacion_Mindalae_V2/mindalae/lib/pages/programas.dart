import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProgramasScreen extends StatefulWidget {
  final void Function(int index)? onItemSelected;

  const ProgramasScreen({super.key, this.onItemSelected});

  @override
  State<ProgramasScreen> createState() => _ProgramasScreenState();
}

class _ProgramasScreenState extends State<ProgramasScreen> {
  final List<bool> _liked = List.generate(
    13,
    (index) => false,
  ); // 'final' aplicado
  final List<String> _programNames = [
    'Alimenta tu Ingenio',
    'Allpallamkay',
    'Café Cognitivo',
    'Comex tu Voz',
    'De Mente Pública',
    'Diálogos y Saberes',
    'Frecuencia Turística',
    'Generación 4.0',
    'Ikigai Emprendedor',
    'Info-Salud al Aire',
    'La Pizarra',
    'Logic Waves',
    'Por tu Bienestar',
  ];

  @override
  void initState() {
    super.initState();
    cargarLikes(); // Llamás a tu función aquí
  }

  Future<void> cargarLikes() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc =
        await FirebaseFirestore.instance
            .collection('likes')
            .doc(user.uid)
            .get();

    if (doc.exists) {
      final data = doc.data();
      if (data != null) {
        setState(() {
          for (int i = 0; i < _programNames.length; i++) {
            final programName = _programNames[i];
            _liked[i] = data[programName] == true;
          }
        });
      }
    }
  }

  // Función para guardar en Firestore
  Future<void> guardarLike(String programaId, bool liked) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = FirebaseFirestore.instance.collection('likes').doc(user.uid);
    await docRef.set({
      programaId: liked.toString(), // Guardamos como "true"/"false"
    }, SetOptions(merge: true)); // merge para mantener los demás programas
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'PROGRAMAS',
          style: TextStyle(
            color: Color.fromRGBO(255, 206, 0, 1),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _programNames.length, // Cambié esto a _programNames.length
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 16,
                  ),
                  backgroundColor: const Color.fromARGB(103, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                  elevation: 1,
                ),
                onPressed: () {
                  if (_programNames[index] == 'Alimenta tu Ingenio') {
                    widget.onItemSelected?.call(
                      4,
                    ); // Cambia al índice de Generacion4Screen
                  } /*else {
                    // Aquí puedes mostrar un mensaje o hacer otra acción
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Botón de ${_programNames[index]} presionado',
                        ),
                      ),
                    );
                  }*/ // Acción al presionar el botón
                  if (_programNames[index] == 'Allpallamkay') {
                    widget.onItemSelected?.call(
                      5,
                    ); // Cambia al índice de Generacion4Screen
                  }
                  if (_programNames[index] == 'Café Cognitivo') {
                    widget.onItemSelected?.call(
                      6,
                    ); // Cambia al índice de Generacion4Screen
                  }
                  if (_programNames[index] == 'Comex tu Voz') {
                    widget.onItemSelected?.call(
                      7,
                    ); // Cambia al índice de Generacion4Screen
                  }
                  if (_programNames[index] == 'De Mente Pública') {
                    widget.onItemSelected?.call(
                      8,
                    ); // Cambia al índice de Generacion4Screen
                  }
                  if (_programNames[index] == 'Diálogos y Saberes') {
                    widget.onItemSelected?.call(
                      9,
                    ); // Cambia al índice de Generacion4Screen
                  }
                  if (_programNames[index] == 'Frecuencia Turística') {
                    widget.onItemSelected?.call(
                      10,
                    ); // Cambia al índice de Generacion4Screen
                  }
                  if (_programNames[index] == 'Generación 4.0') {
                    widget.onItemSelected?.call(
                      11,
                    ); // Cambia al índice de Generacion4Screen
                  }
                  if (_programNames[index] == 'Ikigai Emprendedor') {
                    widget.onItemSelected?.call(
                      12,
                    ); // Cambia al índice de Generacion4Screen
                  }
                  if (_programNames[index] == 'Info-Salud al Aire') {
                    widget.onItemSelected?.call(
                      13,
                    ); // Cambia al índice de Generacion4Screen
                  }
                  if (_programNames[index] == 'La Pizarra') {
                    widget.onItemSelected?.call(
                      14,
                    ); // Cambia al índice de Generacion4Screen
                  }
                  if (_programNames[index] == 'Logic Waves') {
                    widget.onItemSelected?.call(
                      15,
                    ); // Cambia al índice de Generacion4Screen
                  }
                  if (_programNames[index] == 'Por tu Bienestar') {
                    widget.onItemSelected?.call(
                      16,
                    ); // Cambia al índice de Generacion4Screen
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      // Se agrega Expanded para que ocupe todo el espacio
                      child: Center(
                        // Se centra el texto
                        child: Text(
                          _programNames[index], // Aquí uso el nombre del programa
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color.fromRGBO(255, 206, 0, 1),
                          ),
                          textAlign:
                              TextAlign
                                  .center, // Esto asegura que el texto esté centrado
                        ),
                      ),
                    ),
                    StreamBuilder<User?>(
                      stream: FirebaseAuth.instance.authStateChanges(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(); // o CircularProgressIndicator si querés
                        }

                        if (!snapshot.hasData) {
                          // No hay usuario autenticado → ocultamos el botón
                          return const SizedBox.shrink();
                        }

                        // Usuario autenticado → mostramos el botón
                        return IconButton(
                          icon: Icon(
                            _liked[index]
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color:
                                _liked[index]
                                    ? const Color.fromRGBO(255, 206, 0, 1)
                                    : const Color.fromARGB(255, 255, 254, 254),
                          ),
                          onPressed: () async {
                            final user = FirebaseAuth.instance.currentUser;
                            if (user == null) return;

                            setState(() {
                              _liked[index] = !_liked[index];
                            });

                            // Guardar en Firestore
                            final programName = _programNames[index];
                            await FirebaseFirestore.instance
                                .collection('likes')
                                .doc(user.uid)
                                .set({
                                  programName: _liked[index],
                                }, SetOptions(merge: true));
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

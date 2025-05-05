import 'package:flutter/material.dart';

class BarraInferior extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onIconPressed;
  final Color color; // Aceptamos el color como parámetro

  const BarraInferior({
    Key? key,
    required this.selectedIndex,
    required this.onIconPressed,
    required this.color, // Recibimos el color aquí
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final icons = [
      Icons.radio_outlined,
      Icons.tv,
      Icons.video_collection_outlined,
    ];

    return Container(
      color: color, // Usamos el color pasado como parámetro
      padding: const EdgeInsets.all(25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(icons.length, (index) {
          return IconButton(
            icon: Icon(
              icons[index],
              size: 40,
              color:
                  selectedIndex == index
                      ? const Color.fromRGBO(255, 206, 0, 1)
                      : const Color.fromARGB(255, 97, 97, 97),
              shadows:
                  selectedIndex == index
                      ? [
                        const Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 6,
                          color: Color.fromARGB(255, 95, 89, 6),
                        ),
                        Shadow(
                          offset: const Offset(-1, -1),
                          blurRadius: 1,
                          color: const Color.fromARGB(
                            255,
                            254,
                            255,
                            245,
                          ).withOpacity(0.2),
                        ),
                      ]
                      : [],
            ),
            onPressed:
                () => onIconPressed(
                  index,
                ), // Llama a la función para cambiar el índice
          );
        }),
      ),
    );
  }
}

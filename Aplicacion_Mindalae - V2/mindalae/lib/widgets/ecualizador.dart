import 'package:flutter/material.dart';
import 'dart:math';

// === PAINTER PERSONALIZADO CON EFECTO LATIDO Y ALTURA MAYOR ===
class EqualizerPainter extends CustomPainter {
  final double animationValue;

  EqualizerPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    int barCount = 100;
    double baseWidth = size.width / (barCount * 1.2);
    double space = baseWidth * 0.8;

    double centerX = size.width / 2;
    double centerY = size.height / 2;

    // Efecto latido tipo "pum pum" más grande
    double zoom =
        1.0 + sin(animationValue * pi) * 0.16; // Aumentar el factor de zoom

    // Efecto de sombra/neón más grande
    double backgroundZoom = 1.0 + cos(animationValue * pi) * 0.05;

    for (int i = 0; i < barCount; i++) {
      double offset = i - (barCount / 2);
      double distance = offset.abs() / (barCount / 2);

      double heightScale = 1.2 - (distance * 0.8);
      double widthScale = 1.0 - (1 - distance) * 0.7;

      double dynamicWidth = baseWidth * widthScale * zoom;
      double dynamicWidthBackground = baseWidth * widthScale * backgroundZoom;

      double x = centerX + offset * (dynamicWidth + space * zoom);

      // Para el efecto de fondo con sombra o resplandor
      double xBackground =
          centerX + offset * (dynamicWidthBackground + space * backgroundZoom);

      double wave = sin(animationValue * 2 * pi + i * 0.35);
      double heightFactor =
          (wave + 1.5) *
          50 *
          heightScale *
          zoom; // Aumentar el impacto de la altura

      double barHeight = size.height / 100 + heightFactor;

      // Colores para las barras
      Color color =
          HSVColor.lerp(
            HSVColor.fromColor(const Color.fromRGBO(255, 152, 0, 1)),
            HSVColor.fromColor(const Color.fromARGB(255, 0, 0, 0)),
            i / barCount,
          )!.toColor();

      final Paint paint =
          Paint()
            ..color = color.withOpacity(1)
            ..style = PaintingStyle.fill;

      // Dibuja las barras con el efecto de latido
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(x, centerY),
            width: dynamicWidth,
            height: barHeight,
          ),
          const Radius.circular(4),
        ),
        paint,
      );

      // Dibuja el fondo con un "neón" (resplandor)
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(xBackground, centerY),
            width: dynamicWidthBackground,
            height: barHeight,
          ),
          const Radius.circular(4),
        ),
        paint
          ..color = const Color.fromARGB(255, 242, 242, 239).withOpacity(
            0.2,
          ) // Color de "neón"
          ..maskFilter = MaskFilter.blur(
            BlurStyle.normal,
            5.0,
          ), // Efecto de difuso/iluminado
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

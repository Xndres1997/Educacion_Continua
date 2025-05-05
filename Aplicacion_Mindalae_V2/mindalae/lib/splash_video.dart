import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:mindalae/main.dart';
// Asegúrate de importar correctamente

class SplashVideoScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const SplashVideoScreen({Key? key, required this.onToggleTheme})
    : super(key: key);

  @override
  _SplashVideoScreenState createState() => _SplashVideoScreenState();
}

class _SplashVideoScreenState extends State<SplashVideoScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/mindalaev.mp4')
      ..initialize().then((_) {
        setState(() {}); // Para mostrar el primer frame
        _controller.play();
      });

    _controller.addListener(() {
      if (_controller.value.position >= _controller.value.duration) {
        // Ir a la pantalla principal después del video
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => PrincipalScreen(
                  onToggleTheme:
                      widget.onToggleTheme, // <-- Aquí usamos el real
                ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:
          _controller.value.isInitialized
              ? Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              )
              : Container(color: Colors.black),
    );
  }
}

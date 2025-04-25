import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class TvPlayerScreen extends StatefulWidget {
  final String streamUrl;

  const TvPlayerScreen({Key? key, required this.streamUrl}) : super(key: key);

  @override
  _TvPlayerScreenState createState() => _TvPlayerScreenState();
}

class _TvPlayerScreenState extends State<TvPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();

    // Inicializamos el VideoPlayerController con la URL del stream
    _videoPlayerController = VideoPlayerController.network(widget.streamUrl)
      ..initialize().then((_) {
        if (mounted) {
          // Comprobamos si el widget sigue montado
          setState(() {
            _chewieController = ChewieController(
              videoPlayerController: _videoPlayerController,
              autoPlay: true, // Iniciar la reproducción automáticamente
              looping: true, // Repetir el video
              allowFullScreen: true, // Permitir pantalla completa
              allowPlaybackSpeedChanging:
                  false, // No permitir cambiar la velocidad de reproducción
              errorBuilder: (context, errorMessage) {
                return Center(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              },
            );
          });
        }
      });
  }

  @override
  void dispose() {
    // Asegúrate de liberar los recursos cuando ya no sean necesarios
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'TV ONLINE',
          style: TextStyle(
            color: Color.fromRGBO(255, 206, 0, 1),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        //BOTON DE IR HACIA ATRAS NO FUNCIONA
        /*leading: IconButton(
          icon: const Icon(
            Icons.arrow_circle_left_rounded,
            color: Color.fromRGBO(255, 206, 0, 1),
            size: 40,
          ),
          onPressed: () {
            Navigator.pop(context); // Volver a la pantalla anterior
          },
        ),*/
      ),
      body: Center(
        child:
            _chewieController != null &&
                    _chewieController!.videoPlayerController.value.isInitialized
                ? Chewie(controller: _chewieController!) // Reproductor de video
                : const CircularProgressIndicator(color: Colors.amber),
      ),
    );
  }
}

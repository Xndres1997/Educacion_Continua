import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class InfosaludAlAire extends StatefulWidget {
  final VoidCallback onBack;

  const InfosaludAlAire({super.key, required this.onBack});

  @override
  State<InfosaludAlAire> createState() => _InfosaludAlAireState();
}

class _InfosaludAlAireState extends State<InfosaludAlAire> {
  late WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Configuración específica para plataformas
    _setupWebView();
  }

  void _setupWebView() {
    // Configuración avanzada del controlador
    final platformController =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageFinished: (String url) {
                setState(() => _isLoading = false);
              },
            ),
          )
          ..loadRequest(
            Uri.parse(
              'https://www.youtube.com/watch?v=sqq5i9y5uwU&list=PL1GsrUqNhGM8wLpDgGzZu7qML5VN7VVOF',
            ),
          );

    // Configuraciones específicas para Android
    if (platformController.platform is AndroidWebViewController) {
      (platformController.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false); // Permite autoplay
    }

    _controller = platformController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 157, 157, 156),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_circle_left_outlined,
            color: Color.fromRGBO(255, 206, 0, 1),
            size: 35,
          ),
          onPressed: widget.onBack,
        ),
        centerTitle: true,
        title: const Text(
          'INFO-SALUD AL AIRE',
          style: TextStyle(
            color: Color.fromRGBO(255, 206, 0, 1),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: const Color.fromRGBO(157, 157, 156, 1),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  WebViewWidget(controller: _controller),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

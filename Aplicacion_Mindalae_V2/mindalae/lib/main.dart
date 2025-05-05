import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'widgets/botonesbarrainferior.dart';
import 'pages/tv.dart';
import 'pages/programas.dart';
import 'package:volume_controller/volume_controller.dart';
import 'widgets/ecualizador.dart';
import 'dart:async';
import 'pages/login.dart';
import 'widgets/menu_lateral.dart';
import 'pages/programas/programas_export.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'splash_video.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'connection_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  // Estado para el tema (modo claro u oscuro)
  ThemeMode _themeMode = ThemeMode.light;

  // Función que alterna el tema
  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashVideoScreen(
        onToggleTheme: _toggleTheme,
      ), // Pasa la función al widget
      theme: ThemeData.light(), // Modo claro
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2D2D2D),
          iconTheme: IconThemeData(color: Color.fromRGBO(255, 206, 0, 1)),
          titleTextStyle: TextStyle(
            color: Color.fromRGBO(255, 206, 0, 1),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Color.fromRGBO(255, 206, 0, 1)),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          titleLarge: TextStyle(
            color: Color.fromRGBO(255, 206, 0, 1),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        sliderTheme: const SliderThemeData(
          activeTrackColor: Color.fromRGBO(255, 206, 0, 1),
          inactiveTrackColor: Colors.grey,
          thumbColor: Color.fromRGBO(255, 206, 0, 1),
        ),
        drawerTheme: const DrawerThemeData(backgroundColor: Color(0xFF2D2D2D)),
      ),
      themeMode: _themeMode, // Usa el tema actual
    );
  }
}

class PrincipalScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const PrincipalScreen({super.key, required this.onToggleTheme});

  @override
  State<PrincipalScreen> createState() => _PrincipalScreenState();
}

class _PrincipalScreenState extends State<PrincipalScreen> {
  int _selectedIndex = 0;

  // Función que cambia el índice cuando se presiona un icono
  void _onIconPressed(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Funcion cuadro de dialogo para salir de la app
  Future<bool> _onWillPop() async {
    if (_selectedIndex == 0) {
      bool? exitConfirmed = await showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              backgroundColor: Colors.grey[900], // Fondo gris oscuro
              title: const Text(
                '¿Salir de la app?',
                style: TextStyle(
                  color: Colors.white, // Texto blanco
                  fontWeight: FontWeight.bold, // Negrita
                ),
              ),
              content: const Text(
                '¿Estás seguro de que quieres salir?',
                style: TextStyle(
                  color: Colors.white, // Texto blanco
                  fontSize: 16,
                ),
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white, // Color texto blanco
                  ),
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, // Negrita
                    ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white, // Color texto blanco
                  ),
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(
                    'Salir',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, // Negrita
                    ),
                  ),
                ),
              ],
            ),
      );
      return exitConfirmed ?? false;
    } else {
      // Manejar navegación hacia atrás según la pantalla actual
      if (_selectedIndex == 3) {
        // LoginScreen: volver a índice 0
        setState(() => _selectedIndex = 0);
        return false;
      } else if (_selectedIndex >= 4) {
        // Programas específicos: volver a ProgramasScreen (índice 2)
        setState(() => _selectedIndex = 2);
        return false;
      } else {
        // Otras pantallas (TV y Programas): volver a inicio (índice 0)
        setState(() => _selectedIndex = 0);
        return false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      RadioPlayerScreenContent(onLoginPressed: () => _onIconPressed(3)),
      const TvPlayerScreen(
        streamUrl: 'https://vid2.ecuamedia.net/upectv/Stream1/playlist.m3u8',
      ),
      ProgramasScreen(onItemSelected: _onIconPressed),

      LoginScreen(
        onBack: () {
          setState(() {
            _selectedIndex = 0;
          });
        },
      ),
      AlimentaTuIngenio(
        onBack: () {
          setState(() {
            _selectedIndex = 2;
          });
        },
      ),
      Allpallamkay(
        onBack: () {
          setState(() {
            _selectedIndex = 2;
          });
        },
      ),
      CafeCognitivo(
        onBack: () {
          setState(() {
            _selectedIndex = 2;
          });
        },
      ),
      ComexTuVoz(
        onBack: () {
          setState(() {
            _selectedIndex = 2;
          });
        },
      ),
      DeMentePublica(
        onBack: () {
          setState(() {
            _selectedIndex = 2;
          });
        },
      ),
      DialogosYSaberes(
        onBack: () {
          setState(() {
            _selectedIndex = 2;
          });
        },
      ),
      FrecuenciaTuristica(
        onBack: () {
          setState(() {
            _selectedIndex = 2;
          });
        },
      ),
      Generacion40Screen(
        onBack: () {
          setState(() {
            _selectedIndex = 2;
          });
        },
      ),
      IkigaiEmprendedor(
        onBack: () {
          setState(() {
            _selectedIndex = 2;
          });
        },
      ),
      InfosaludAlAire(
        onBack: () {
          setState(() {
            _selectedIndex = 2;
          });
        },
      ),
      LaPizarra(
        onBack: () {
          setState(() {
            _selectedIndex = 2;
          });
        },
      ),
      LogicWaves(
        onBack: () {
          setState(() {
            _selectedIndex = 2;
          });
        },
      ),
      PorTuBienestar(
        onBack: () {
          setState(() {
            _selectedIndex = 2;
          });
        },
      ),
    ];

    return WillPopScope(
      onWillPop: _onWillPop,
      /*() async {
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
          return false; // Evita que la app se cierre
        }
        return true; // Permite que la app se cierre si ya está en la pantalla principal
      },*/
      child: Scaffold(
        drawer: MenuLateral(
          onItemSelected: _onIconPressed,
          onToggleTheme: widget.onToggleTheme,
        ), // ← aquí está el Drawer
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        body: _pages[_selectedIndex],
        bottomNavigationBar: BarraInferior(
          selectedIndex: _selectedIndex,
          onIconPressed: _onIconPressed,
          color: _getBottomNavColor(),
        ),
      ),
    );
  }

  // Función que devuelve el color según el índice
  Color _getBottomNavColor() {
    switch (_selectedIndex) {
      case 0:
        return const Color.fromARGB(255, 0, 0, 0); // Color para Radio
      case 1:
        return const Color.fromARGB(255, 0, 0, 0); // Color para TV
      case 2:
        return const Color.fromARGB(255, 0, 0, 0); // Color para Programas
      case 3:
        return const Color.fromARGB(255, 0, 0, 0); // Color para Login
      default:
        return const Color.fromARGB(255, 0, 0, 0); // Color por defecto
    }
  }
}

class RadioPlayerScreenContent extends StatefulWidget {
  final VoidCallback onLoginPressed;

  const RadioPlayerScreenContent({super.key, required this.onLoginPressed});

  @override
  State<RadioPlayerScreenContent> createState() =>
      _RadioPlayerScreenContentState();
}

class _RadioPlayerScreenContentState extends State<RadioPlayerScreenContent>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isLoading = false;
  bool isDisposed = false;
  double _volume = 0.5;
  late AnimationController _animationController;
  late StreamSubscription<double> _volumeSubscription;

  void _initAudio() {
    _audioPlayer
      ..setReleaseMode(ReleaseMode.stop)
      ..setPlayerMode(PlayerMode.mediaPlayer)
      ..onPlayerStateChanged.listen((state) {
        if (isDisposed) return;
        setState(() => isPlaying = state == PlayerState.playing);
      });
  }

  @override
  void initState() {
    super.initState();
    VolumeController().showSystemUI = false;

    VolumeController().getVolume().then((volume) {
      setState(() {
        _volume = volume;
      });
      _audioPlayer.setVolume(volume);
    });

    _volumeSubscription = VolumeController().listener((volume) {
      setState(() {
        _volume = volume;
      });
      _audioPlayer.setVolume(volume);
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..stop();
    _initAudio();
  }

  @override
  void dispose() {
    isDisposed = true;
    _animationController.dispose();
    _volumeSubscription.cancel();
    _audioPlayer
      ..stop()
      ..dispose();
    super.dispose();
  }

  bool _isLoading = false;

  void _togglePlay() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      if (isPlaying) {
        await _audioPlayer.pause();
        _animationController.stop();
        setState(() => isPlaying = false);
      } else {
        // Escuchar cambios de estado del reproductor
        _audioPlayer.onPlayerStateChanged.listen((state) {
          if (state == PlayerState.playing) {
            setState(() {
              isPlaying = true;
              _isLoading = false;
            });
            _animationController.repeat(reverse: true);
          }
        });

        // Manejar errores a través del estado
        _audioPlayer.onPlayerStateChanged.listen((state) {
          if (state == PlayerState.stopped) {
            setState(() {
              _isLoading = false;
              isPlaying = false;
            });
            _animationController.stop();
          }
        });

        await _audioPlayer.play(
          UrlSource('https://grupomundodigital.com:8646/live'),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        isPlaying = false;
      });
      _animationController.stop();
      print('Error de reproducción: $e');
    } finally {
      if (!isPlaying) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _setVolume(double value) {
    setState(() {
      _volume = value;
    });
    VolumeController().setVolume(value);
    _audioPlayer.setVolume(value);
  }

  void _increaseVolume() {
    if (_volume < 1) _setVolume((_volume + 0.1).clamp(0, 1));
  }

  void _decreaseVolume() {
    if (_volume > 0) _setVolume((_volume - 0.1).clamp(0, 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'MINDALAE',
          style: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 1),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            size: 35,
            color: Color.fromRGBO(255, 206, 0, 1),
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        actions: [
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              }

              if (snapshot.hasData) {
                return IconButton(
                  icon: const Icon(
                    Icons.exit_to_app,
                    color: Color.fromRGBO(255, 206, 0, 1),
                    size: 35,
                  ),
                  onPressed: () async {
                    bool? confirmExit = await showDialog<bool>(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            backgroundColor:
                                Colors.grey[900], // Fondo gris oscuro
                            title: const Text(
                              'Cerrar sesión',
                              style: TextStyle(
                                color: Colors.white, // Letra blanca título
                                fontWeight: FontWeight.bold, // Negrita
                              ),
                            ),
                            content: const Text(
                              '¿Estás seguro de que deseas salir?',
                              style: TextStyle(
                                color: Colors.white, // Letra blanca contenido
                                fontSize: 16,
                              ),
                            ),
                            actions: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor:
                                      Colors.white, // Color texto blanco
                                ),
                                onPressed:
                                    () => Navigator.of(context).pop(false),
                                child: const Text(
                                  'Cancelar',
                                  style: TextStyle(
                                    fontWeight:
                                        FontWeight.bold, // Texto en negrita
                                  ),
                                ),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor:
                                      Colors.white, // Color texto blanco
                                ),
                                onPressed:
                                    () => Navigator.of(context).pop(true),
                                child: const Text(
                                  'Confirmar',
                                  style: TextStyle(
                                    fontWeight:
                                        FontWeight.bold, // Texto en negrita
                                  ),
                                ),
                              ),
                            ],
                          ),
                    );

                    if (confirmExit == true) {
                      final connectionService = ConnectionService();
                      await connectionService.eliminarConexion();
                      await GoogleSignIn().signOut();
                      await FirebaseAuth.instance.signOut();

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  PrincipalScreen(onToggleTheme: () {}),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    }
                  },
                );
              }

              // Si no hay usuario autenticado, mostrar el icono para iniciar sesión

              return IconButton(
                icon: const Icon(
                  Icons.person_add_alt_1_rounded,
                  color: Color.fromRGBO(255, 206, 0, 1),
                  size: 35,
                ),
                onPressed: widget.onLoginPressed,
              );
            },
          ),
        ],
        elevation: 0,
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          // Si la orientación es horizontal, permitimos scroll siempre
          final isHorizontal =
              MediaQuery.of(context).orientation == Orientation.landscape;

          final content = Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                'RADIO ONLINE',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(255, 206, 0, 1),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 205,
                height: 205,
                child: Image.asset('assets/logo1.png', fit: BoxFit.contain),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                height: 200,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: EqualizerPainter(_animationController.value),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.volume_down,
                        color: Color.fromRGBO(255, 206, 0, 1),
                        size: 40,
                      ),
                      onPressed: _decreaseVolume,
                    ),
                    Expanded(
                      child: Slider(
                        value: _volume,
                        onChanged: _setVolume,
                        min: 0,
                        max: 1,
                        activeColor: const Color.fromRGBO(255, 206, 0, 1),
                        inactiveColor: const Color.fromARGB(255, 98, 96, 96),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.volume_up,
                        color: Color.fromRGBO(255, 206, 0, 1),
                        size: 40,
                      ),
                      onPressed: _increaseVolume,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              IconButton(
                icon:
                    _isLoading
                        ? SizedBox(
                          width: 80,
                          height: 80,
                          child: CircularProgressIndicator(
                            color: const Color.fromRGBO(255, 206, 0, 1),
                            strokeWidth: 3,
                          ),
                        )
                        : Icon(
                          isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                          size: 80,
                          color: const Color.fromRGBO(255, 206, 0, 1),
                        ),
                onPressed: _isLoading ? null : _togglePlay,
              ),
              const SizedBox(height: 40),
            ],
          );

          // Si el contenido es más grande que la altura disponible o estamos en horizontal, usamos scroll
          return (constraints.maxHeight < 700 || isHorizontal)
              ? SingleChildScrollView(child: content)
              : content;
        },
      ),
    );
  }
}

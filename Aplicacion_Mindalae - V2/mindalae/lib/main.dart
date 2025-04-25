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
      home: PrincipalScreen(
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
        sliderTheme: SliderThemeData(
          activeTrackColor: const Color.fromRGBO(255, 206, 0, 1),
          inactiveTrackColor: Colors.grey,
          thumbColor: const Color.fromRGBO(255, 206, 0, 1),
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
      onWillPop: () async {
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
          return false; // Evita que la app se cierre
        }
        return true; // Permite que la app se cierre si ya está en la pantalla principal
      },
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
  double _volume = 0.5;
  late AnimationController _animationController;
  late StreamSubscription<double> _volumeSubscription;

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
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _animationController.dispose();
    _volumeSubscription.cancel();
    super.dispose();
  }

  void _togglePlay() async {
    if (isPlaying) {
      await _audioPlayer.pause();
      _animationController.stop();
    } else {
      await _audioPlayer.play(
        UrlSource('https://grupomundodigital.com:8646/stream'),
      );
      _animationController.repeat(reverse: true);
    }
    setState(() {
      isPlaying = !isPlaying;
    });
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
                return const SizedBox(); // Loader opcional
              }

              if (snapshot.hasData) {
                return const SizedBox.shrink(); // Oculta el botón si está logueado
              }

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
                        inactiveColor: Colors.black,
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
                icon: Icon(
                  isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_fill,
                  size: 80,
                  color: const Color.fromRGBO(255, 206, 0, 1),
                ),
                onPressed: _togglePlay,
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

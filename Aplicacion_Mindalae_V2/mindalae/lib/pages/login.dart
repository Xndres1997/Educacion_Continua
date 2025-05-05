import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mindalae/connection_service.dart';
import 'package:mindalae/main.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onBack;
  const LoginScreen({super.key, required this.onBack});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _connectionService = ConnectionService();
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _emailVerified = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!userCredential.user!.emailVerified) {
        await _showEmailVerificationDialog(userCredential.user!);
        setState(() => _emailVerified = false);
        return;
      }

      await _handleSuccessfulLogin(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _showEmailVerificationDialog(User user) async {
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Verificación requerida'),
            content: const Text(
              'Debes verificar tu correo electrónico antes de continuar. '
              '¿Deseas que reenviemos el enlace de verificación?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  await user.sendEmailVerification();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('¡Enlace reenviado! Revisa tu correo'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Reenviar'),
              ),
            ],
          ),
    );
  }

  Future<void> _loginWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        await _showWelcomeDialog(userCredential.user!);
      }

      await _handleSuccessfulLogin(userCredential.user!);
    } catch (e) {
      _showErrorSnackbar('Error en autenticación con Google: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _showWelcomeDialog(User user) async {
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('¡Bienvenido a Mindalae!'),
            content: Text(
              'Hola ${user.displayName ?? ''}, gracias por unirte a nuestra comunidad.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Comenzar',
                  style: TextStyle(color: Color.fromRGBO(255, 206, 0, 1)),
                ),
              ),
            ],
          ),
    );
  }

  Future<void> _handleSuccessfulLogin(User user) async {
    await _connectionService.registrarConexion();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => PrincipalScreen(onToggleTheme: () {}),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }

  /* void _handleAuthError(FirebaseAuthException e) {
    String errorMessage = 'Error de autenticación';
    switch (e.code) {
      case 'user-not-found':
        errorMessage = 'No existe una cuenta con este correo';
        break;
      case 'wrong-password':
        errorMessage = 'Contraseña incorrecta';
        break;
      case 'invalid-email':
        errorMessage = 'Formato de correo inválido';
        break;
      case 'user-disabled':
        errorMessage = 'Cuenta deshabilitada';
        break;
      case 'too-many-requests':
        errorMessage = 'Demasiados intentos. Intenta más tarde';
        break;
    }
    _showErrorSnackbar(errorMessage);
  }*/

  void _handleAuthError(FirebaseAuthException e) {
    _showErrorSnackbar('Código de error: ${e.code} - Mensaje: ${e.message}');
  }

  Future<void> _resetPassword() async {
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      _showErrorSnackbar('Ingresa un correo válido para restablecer');
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
      _showSuccessSnackbar('Correo de recuperación enviado con éxito');
    } on FirebaseAuthException catch (e) {
      _showErrorSnackbar('Error: ${e.message}');
    }
  }

  void _showErrorSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showSuccessSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'ACCEDE A TU CUENTA',
          style: TextStyle(
            color: Color.fromRGBO(255, 206, 0, 1),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(
                  color: Color.fromRGBO(255, 206, 0, 1),
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.account_circle_outlined,
                          size: 100,
                          color: Color.fromRGBO(255, 206, 0, 1),
                        ),
                        const SizedBox(height: 40),
                        _buildEmailField(),
                        const SizedBox(height: 20),
                        _buildPasswordField(),
                        const SizedBox(height: 10),
                        _buildForgotPassword(),
                        const SizedBox(height: 30),
                        _buildLoginButton(),
                        const SizedBox(height: 25),
                        _buildDivider(),
                        const SizedBox(height: 25),
                        _buildGoogleButton(),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(color: Colors.black),
      decoration: _inputDecoration('Correo electrónico', Icons.email_outlined),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingresa tu correo';
        }
        if (!value.contains('@') || !value.contains('.')) {
          return 'Ingresa un correo válido';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: const TextStyle(color: Colors.black),
      decoration: _inputDecoration('Contraseña', Icons.lock_outlined).copyWith(
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingresa tu contraseña';
        }
        if (value.length < 6) {
          return 'Mínimo 6 caracteres';
        }
        return null;
      },
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: _resetPassword,
        child: const Text(
          '¿Olvidaste tu contraseña?',
          style: TextStyle(color: Color.fromRGBO(255, 206, 0, 1), fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(255, 206, 0, 1),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: const Text(
          'INGRESAR',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Row(
      children: [
        Expanded(child: Divider(color: Colors.white54)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'O continúa con',
            style: TextStyle(color: Colors.white70),
          ),
        ),
        Expanded(child: Divider(color: Colors.white54)),
      ],
    );
  }

  Widget _buildGoogleButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: Image.asset('assets/google_logo.png', width: 24, height: 24),
        label: const Text(
          'Ingresar con Google',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: const BorderSide(color: Color.fromARGB(136, 177, 177, 177)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: _loginWithGoogle,
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white.withOpacity(0.9),
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black54),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      prefixIcon: Icon(icon, color: Colors.grey),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    );
  }
}

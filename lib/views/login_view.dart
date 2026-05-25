import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'productos_view.dart'; // Crearemos este archivo en el siguiente paso

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // Controladores para capturar lo que el usuario escribe en la pantalla
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  final AuthService _authService = AuthService();
  bool _isLoading = false;

  // Función interna para manejar el botón de Login
  void _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    String? token = await _authService.login(
      _userController.text.trim(),
      _passController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    if (token != null) {
      // 🔑 DECODIFICACIÓN DEL JWT
      // Abrimos el token para extraer la data en un mapa de Dart
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

      // Accedemos a la lista 'role', tomamos el primer objeto y extraemos su 'authority'
      String userRole = decodedToken['role'][0]['authority'];

      // Si el backend nos dio un token válido, viajamos a la pantalla de productos
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProductosView(
              token: token,
              role: userRole, // 👈 Pasamos el rol ("ROLE_USER" o "ROLE_ADMIN")
            ),
          ),
        );
      }
    } else {
      // Si falló, mostramos una alerta en pantalla
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Credenciales incorrectas o error de red')),
        );
      }
    }
  }

  // Función interna para manejar el botón de Registro
  void _handleRegister() async {
    setState(() {
      _isLoading = true;
    });

    bool exito = await _authService.register(
      _userController.text.trim(),
      _passController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(exito
                ? '¡Usuario registrado en Docker!'
                : 'Error al registrar')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Autenticación - API Productos')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_outline, size: 80, color: Colors.blue),
                const SizedBox(height: 20),
                TextField(
                  controller: _userController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de Usuario',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _passController,
                  obscureText: true, // Oculta la contraseña con puntitos
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 25),
                _isLoading
                    ? const CircularProgressIndicator()
                    : Column(
                        // Esto le dice a la columna que estire todos sus elementos hijos a lo ancho
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            onPressed: _handleLogin,
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(50)),
                            child: const Text('Iniciar Sesión'),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: _handleRegister,
                            child: const Text('Registrar nuevo usuario'),
                          ),
                        ],
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

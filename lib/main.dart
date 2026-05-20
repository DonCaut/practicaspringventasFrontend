import 'package:flutter/material.dart';
import 'views/login_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema de Productos',
      debugShowCheckedModeBanner: false, // Quita la etiqueta roja de "Debug"
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true, // Usa el diseño moderno de Google
      ),
      home: const LoginView(), // Definimos que la primera pantalla sea el Login
    );
  }
}

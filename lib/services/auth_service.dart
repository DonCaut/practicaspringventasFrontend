import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // REGLA DE ORO DE LA IP:
  // - Si usas el emulador de Android Studio, usa: 'http://10.0.2.2:8080/api/auth'
  // - Si pruebas en navegador Web o celular físico por USB, usa la IP de tu PC o 'http://localhost:8080/api/auth'
  final String baseUrl = 'http://localhost:8080/api/auth';

  // Método para registrar un nuevo usuario
  Future<bool> register(String username, String password) async {
    final url = Uri.parse('$baseUrl/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return true; // Registro exitoso
      } else {
        print('Error en registro: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error de red al registrar: $e');
      return false;
    }
  }

  // Método para iniciar sesión y obtener el Token JWT
  Future<String?> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Mapeamos la respuesta JSON que nos da tu backend
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data['token']; // Retorna el string gigante eyJ...
      } else {
        print('Error en login: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error de red al loguear: $e');
      return null;
    }
  }
}

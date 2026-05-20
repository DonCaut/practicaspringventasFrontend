import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductoService {
  // Recuerda ajustar la IP según dónde ejecutes Flutter (10.0.2.2 para emulador Android)
  final String baseUrl = 'http://localhost:8080/api/productos';

  // Método para listar productos enviando el Token JWT en la cabecera
  Future<List<dynamic>> obtenerProductos(String token) async {
    final url = Uri.parse(baseUrl);

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // 1. Decodificamos el JSON completo del backend
        final Map<String, dynamic> respuestaCompleta =
            jsonDecode(response.body);

        // 2. Extraemos únicamente la lista que vive dentro de 'data'
        final List<dynamic> listaDeProductos = respuestaCompleta['data'];

        return listaDeProductos;
      } else {
        print('Error al obtener productos: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error de red en productos: $e');
      return [];
    }
  }
}

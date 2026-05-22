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

  //  MÉTODO PARA CREAR UN PRODUCTO (POST)
  Future<bool> crearProducto(
      String token, String nombre, double precio, int stock) async {
    final url = Uri.parse(baseUrl);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'nombre': nombre,
          'precio': precio,
          'stock': stock,
        }),
      );

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print('Error al crear producto: $e');
      return false;
    }
  }

  //  MÉTODO PARA ELIMINAR UN PRODUCTO (DELETE)
  Future<bool> eliminarProducto(String token, int id) async {
    final url = Uri.parse('$baseUrl/$id');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Error al eliminar producto: $e');
      return false;
    }
  }
}

import 'package:flutter/material.dart';
import '../services/producto_service.dart';

class ProductosView extends StatefulWidget {
  final String token; // Aquí guardamos el token que recibimos del login

  const ProductosView({super.key, required this.token});

  @override
  State<ProductosView> createState() => _ProductosViewState();
}

class _ProductosViewState extends State<ProductosView> {
  final ProductoService _productoService = ProductoService();
  List<dynamic> _productos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarProductos(); // En cuanto carga la pantalla, pedimos los datos al backend
  }

  void _cargarProductos() async {
    // Usamos el token para hacer la petición segura
    List<dynamic> data = await _productoService.obtenerProductos(widget.token);

    setState(() {
      _productos = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Productos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () =>
                Navigator.of(context).pop(), // Botón para volver al login
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Rueda de carga
          : _productos.isEmpty
              ? const Center(
                  child: Text('No hay productos disponibles o error de token.'))
              : ListView.builder(
                  itemCount: _productos.length,
                  itemBuilder: (context, index) {
                    final producto = _productos[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
                      child: ListTile(
                        leading:
                            const Icon(Icons.shopping_bag, color: Colors.blue),
                        title: Text(producto['nombre'],
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Precio: \$${producto['precio']}'),
                        trailing: Text('Stock: ${producto['stock']}'),
                      ),
                    );
                  },
                ),
    );
  }
}

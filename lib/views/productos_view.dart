import 'package:flutter/material.dart';
import '../services/producto_service.dart';

class ProductosView extends StatefulWidget {
  final String token;
  final String role; // 👈 Agregamos esta línea
  const ProductosView({Key? key, required this.token, required this.role})
      : super(key: key);

  @override
  @override
  State<ProductosView> createState() => _ProductosViewState();
}

class _ProductosViewState extends State<ProductosView> {
  final ProductoService _productoService = ProductoService();
  List<dynamic> _productos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  // Cargar o refrescar la lista de productos
  Future<void> _cargarProductos() async {
    setState(() => _cargando = true);
    final productos = await _productoService.obtenerProductos(widget.token);
    setState(() {
      _productos = productos;
      _cargando = false;
    });
  }

  // Función para manejar la eliminación
  Future<void> _eliminarProducto(int id, String nombre) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar producto?'),
        content: Text('¿Estás seguro de que deseas eliminar "$nombre"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child:
                  const Text('Eliminar', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirmado == true) {
      final exito = await _productoService.eliminarProducto(widget.token, id);

      // 🛡️ Evita usar BuildContext después de un proceso asíncrono
      if (!mounted) return;

      if (exito) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$nombre eliminado correctamente')),
        );
        _cargarProductos(); // Refrescar la lista
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar el producto')),
        );
      }
    }
  }

  // Función para abrir el formulario de creación
  void _mostrarFormularioCrear() {
    final nombreController = TextEditingController();
    final precioController = TextEditingController();
    final stockController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agregar Nuevo Producto'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nombreController,
                  decoration:
                      const InputDecoration(labelText: 'Nombre del Producto')),
              TextField(
                  controller: precioController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Precio')),
              TextField(
                  controller: stockController,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Stock Inicial')),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              if (nombreController.text.isNotEmpty &&
                  precioController.text.isNotEmpty &&
                  stockController.text.isNotEmpty) {
                final nombre = nombreController.text;
                final precio = double.parse(precioController.text);
                final stock = int.parse(stockController.text);

                Navigator.pop(context); // Cerrar modal

                final exito = await _productoService.crearProducto(
                    widget.token, nombre, precio, stock);

                // 🛡️ Evita usar BuildContext después de un proceso asíncrono
                if (!mounted) return;

                if (exito) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('¡$nombre creado con éxito!')),
                  );
                  _cargarProductos(); // Refrescar la lista automáticamente
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error al crear el producto')),
                  );
                }
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Productos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarProductos, // Botón manual de refrescar
          )
        ],
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _productos.isEmpty
              ? const Center(child: Text('No hay productos disponibles.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _productos.length,
                  itemBuilder: (context, index) {
                    final producto = _productos[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: const Icon(Icons.shopping_bag,
                            color: Colors.blue, size: 40),
                        title: Text(producto['nombre'] ?? 'Sin nombre',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        subtitle: Text(
                            'Precio: \$${producto['precio']}  |  Stock: ${producto['stock']} unidades'),
                        trailing: widget.role == 'ROLE_ADMIN'
                            ? IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _eliminarProducto(
                                    producto['id'], producto['nombre']),
                              )
                            : null, // 👈 Si no es ADMIN, no renderiza nada (queda limpio)
                      ),
                    );
                  },
                ),
      // ➕ BOTÓN FLOTANTE PARA CREAR
      floatingActionButton: widget.role == 'ROLE_ADMIN'
          ? FloatingActionButton(
              onPressed: _mostrarFormularioCrear,
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null, // 👈 Si es USER, el botón azul desaparece por completo
    );
  }
}

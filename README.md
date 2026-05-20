# Sistema de Productos - Frontend (Flutter) 

Este es el frontend del Sistema de Productos, desarrollado en Flutter. Proporciona una interfaz web para autenticar usuarios mediante JWT y gestionar un catálogo de productos consumiendo una API REST.

## 🌐 Configuración de la IP del Backend (¡Crucial!)

La aplicación se comunica con el backend de Spring Boot. Dependiendo de dónde vayas a probar la app, debes ajustar la URL base (`baseUrl`) en el archivo `lib/services/producto_service.dart` (y en el de autenticación):

 **Si pruebas en Web (Edge/Chrome):** Usa `http://localhost:8080`
 ***Si pruebas en Emulador de Android (Android Studio):** El emulador ve a tu computadora local a través de una IP especial. Debes cambiar `localhost` por `10.0.2.2`. Ejemplo: `http://10.0.2.2:8080`
* **Si pruebas en un Dispositivo Físico:** Asegúrate de que el teléfono y la PC estén en la misma red Wi-Fi y usa la IP local de tu PC (ej. `http://192.168.1.XX:8080`).



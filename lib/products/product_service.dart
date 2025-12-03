import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:app_final/authentications/enviroment.dart';
import 'package:app_final/products/product.dart';
import 'package:app_final/authentications/users/token_helper.dart';

class ProductService {
  final String baseUrl = Enviroment.apiUrl;

  /// Obtener lista de productos
  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data is List) {
        return data.map((p) => Product.fromJson(p)).toList();
      }

      final products = (data['data']?['products'] as List<dynamic>? ?? []);
      return products.map((p) => Product.fromJson(p)).toList();
    } else {
      throw Exception('Error al cargar productos: ${response.body}');
    }
  }

  /// Paso 1: subir imagen
  /// Paso 1: subir imagen
Future<String> uploadProductImage(File imageFile) async {
  final token = await TokenHelper.getToken();
  if (token == null || token.isEmpty) {
    throw Exception('No hay token de autenticación. Inicia sesión primero.');
  }

  final uri = Uri.parse('$baseUrl/files/product');
  final request = http.MultipartRequest('POST', uri);

  // adjuntar archivo
  request.files.add(
    await http.MultipartFile.fromPath('file', imageFile.path),
  );

  // encabezado con token
  request.headers['Authorization'] = 'Bearer $token';

  final response = await request.send();
  final respStr = await response.stream.bytesToString();

  print('Respuesta upload: $respStr');

  if (response.statusCode != 201 && response.statusCode != 200) {
    throw Exception('Error al subir imagen: ${response.statusCode} → $respStr');
  }

  final data = json.decode(respStr);

  // 👇 usar la clave correcta que devuelve el backend
  return data['image'] ?? imageFile.path.split('/').last;
}

  /// Paso 2: crear producto en JSON puro
  /// Paso 2: crear producto en JSON puro
Future<void> createProduct(Map<String, dynamic> productData, String imageName) async {
  final token = await TokenHelper.getToken();
  if (token == null || token.isEmpty) {
    throw Exception('No hay token de autenticación. Inicia sesión primero.');
  }

  final uri = Uri.parse('$baseUrl/products');

  final body = {
    "title": productData['title'],
    "description": productData['description'],
    "price": productData['price'],
    "stock": productData['stock'],
    "gender": productData['gender'],
    "slug": productData['slug'],
    "sizes": productData['sizes'], // array directo
    "tags": productData['tags'],   // array directo
    //  aquí usamos el nombre devuelto por uploadProductImage
    "images": [imageName]
  };

  final response = await http.post(
    uri,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode(body),
  );

  print('Respuesta create: ${response.body}');

  if (response.statusCode != 201) {
    throw Exception('Error al crear producto: ${response.statusCode} → ${response.body}');
  }
}
}
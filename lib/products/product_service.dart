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

  /// Crear producto sin imagen (JSON)
  Future<void> createProduct(Map<String, dynamic> productData) async {
    final token = await TokenHelper.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('No hay token de autenticación. Inicia sesión primero.');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(productData),
    );

    if (response.statusCode != 201) {
      throw Exception(
          'Error al crear producto: ${response.statusCode} → ${response.body}');
    }
  }

  /// Crear producto con imagen (Multipart)
  /// Crear producto con imagen (Multipart)
Future<void> createProductWithImage(
  Map<String, dynamic> productData,
  File imageFile,
) async {
  final token = await TokenHelper.getToken();
  if (token == null || token.isEmpty) {
    throw Exception('No hay token de autenticación. Inicia sesión primero.');
  }

  final uri = Uri.parse('$baseUrl/products');
  final request = http.MultipartRequest('POST', uri);

  // Campos simples
  request.fields['title'] = productData['title'];
  request.fields['description'] = productData['description'];
  request.fields['price'] = productData['price'].toString();
  request.fields['stock'] = productData['stock'].toString();
  request.fields['gender'] = productData['gender'];
  request.fields['slug'] = productData['slug'];

  // Arrays como JSON string
  request.fields['sizes'] = json.encode(productData['sizes']); // ["XS","S","M"]
  request.fields['tags'] = json.encode(productData['tags']);   // ["shirt"]

  // Imagen: nombre en array JSON
  final imageName = imageFile.path.split('/').last;
  request.fields['images'] = json.encode([imageName]);

  // Archivo real
  request.files.add(
    await http.MultipartFile.fromPath('images', imageFile.path),
  );

  // Token
  request.headers['Authorization'] = 'Bearer $token';

  // Debug
  print('Campos enviados: ${request.fields}');

  final response = await request.send();
  final respStr = await response.stream.bytesToString();

  print('Respuesta backend: $respStr');

  if (response.statusCode != 201) {
    throw Exception(
        'Error al crear producto con imagen: ${response.statusCode} → $respStr');
  }
}
}
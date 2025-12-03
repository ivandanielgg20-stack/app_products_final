import 'package:app_final/authentications/enviroment.dart';

class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final int stock;
  final String gender;
  final String slug;
  final List<String> sizes;
  final List<String> tags;
  final List<String> images;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.stock,
    required this.gender,
    required this.slug,
    required this.sizes,
    required this.tags,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
  return Product(
    id: json['id'] is int
        ? json['id']
        : int.tryParse(json['id'].toString()) ?? 0,
    title: json['title'] ?? '',
    description: json['description'] ?? '',
    price: json['price'] is int
        ? (json['price'] as int).toDouble()
        : double.tryParse(json['price'].toString()) ?? 0.0,
    stock: json['stock'] is int
        ? json['stock']
        : int.tryParse(json['stock'].toString()) ?? 0,
    gender: json['gender'] ?? '',
    slug: json['slug'] ?? '',
    sizes: (json['sizes'] as List<dynamic>? ?? []).map((s) => s.toString()).toList(),
    tags: (json['tags'] as List<dynamic>? ?? []).map((t) => t.toString()).toList(),
    images: (json['images'] as List<dynamic>? ?? [])
        .map((img) => '${Enviroment.apiUrl}/files/product/$img')
        .toList(),
  );
}}
import 'package:app_final/authentications/enviroment.dart';

class Product {
  final String id;
  final String title;
  final String description;
  final int price;
  final int stock;
  final List<String> sizes;
  final String gender;
  final List<String> tags;
  final List<String> images; // URLs completas
  final String slug;
  final ProductUser user;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.stock,
    required this.sizes,
    required this.gender,
    required this.tags,
    required this.images,
    required this.slug,
    required this.user,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Construcción de URLs de imágenes usando el endpoint correcto
    final rawImages = (json['images'] ?? []) as List;
    final fullImages = rawImages
        .map((e) => '${Enviroment.apiUrl}/files/product/${e.toString()}')
        .toList();

    return Product(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      title: (json['title'] ?? json['name'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      price: int.tryParse(json['price']?.toString() ?? '0') ?? 0,
      stock: int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
      sizes: List<String>.from((json['sizes'] ?? []).map((e) => e.toString())),
      gender: (json['gender'] ?? json['type'] ?? '').toString(),
      tags: List<String>.from((json['tags'] ?? []).map((e) => e.toString())),
      images: fullImages,
      slug: (json['slug'] ?? '').toString(),
      user: ProductUser.fromJson(json['user'] ?? {}),
    );
  }
}

class ProductUser {
  final String id;
  final String email;
  final String fullName;
  final bool isActive;
  final List<String> roles;

  ProductUser({
    required this.id,
    required this.email,
    required this.fullName,
    required this.isActive,
    required this.roles,
  });

  factory ProductUser.fromJson(Map<String, dynamic> json) {
    return ProductUser(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      fullName: (json['fullName'] ?? json['fullname'] ?? '').toString(),
      isActive: (json['isActive'] ?? false) == true,
      roles: List<String>.from((json['roles'] ?? []).map((e) => e.toString())),
    );
  }
}
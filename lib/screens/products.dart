import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app_final/products/product_service.dart';
import 'package:app_final/products/product.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> with RouteAware {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = ProductService().getProducts();
  }

  @override
  void didPopNext() {
    setState(() {
      _productsFuture = ProductService().getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Productos')),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final products = snapshot.data ?? [];

          if (products.isEmpty) {
            return const Center(child: Text('No hay productos'));
          }

          // 👇 Ordenar por id descendente (último creado primero)
          products.sort((a, b) => b.id.compareTo(a.id));

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  title: Text(product.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.description),
                      const SizedBox(height: 8),
                      if (product.images.isNotEmpty)
                        Image.network(
                          product.images.first, // URL completa construida en Product.fromJson
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return const SizedBox(
                              height: 120,
                              child: Center(child: Text('Sin imagen')),
                            );
                          },
                        ),
                    ],
                  ),
                  trailing: Text('\$${product.price}'),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Nuevo producto'),
        icon: const Icon(Icons.add),
        onPressed: () async {
          final created = await context.push('/add-product');
          if (created == true) {
            setState(() {
              _productsFuture = ProductService().getProducts();
            });
          }
        },
      ),
    );
  }
}
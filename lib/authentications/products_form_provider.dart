import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app_final/products/product_service.dart';
import 'package:app_final/products/images/image_picker_provider.dart';

class ProductForm extends ConsumerStatefulWidget {
  const ProductForm({super.key});

  @override
  ConsumerState<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends ConsumerState<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'title': '',
    'description': '',
    'price': '',
    'stock': '',
    'sizes': '',
    'gender': '',
    'tags': '',
  };

  @override
  Widget build(BuildContext context) {
    final imageState = ref.watch(imagePickerProvider);
    final picker = ref.read(imagePickerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Producto')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildText('title'),
              _buildText('description'),
              _buildNumber('price'),
              _buildNumber('stock'),
              _buildText('sizes', hint: 'ej: XS,S,M'),
              _buildText('gender', hint: 'ej: men'),
              _buildText('tags', hint: 'ej: shirt,jacket'),
              const SizedBox(height: 12),
              imageState.imageFile == null
                  ? const Text('No hay imagen seleccionada')
                  : Image.file(imageState.imageFile!, height: 200),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.photo),
                    label: const Text('Galería'),
                    onPressed: () => picker.pickFromGallery(),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Cámara'),
                    onPressed: () => picker.pickFromCamera(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  _formKey.currentState?.save();

                  final title = (_formData['title'] as String).trim();
                  final slug = title
                      .toLowerCase()
                      .replaceAll(RegExp(r"[^\w]+"), "_")
                      .replaceAll(RegExp(r"_+"), "_")
                      .trim();

                  final sizesList = (_formData['sizes'] as String)
                      .split(',')
                      .map((s) => s.trim())
                      .where((s) => s.isNotEmpty)
                      .toList();

                  final tagsList = (_formData['tags'] as String)
                      .split(',')
                      .map((t) => t.trim())
                      .where((t) => t.isNotEmpty)
                      .toList();

                  const validGenders = ['men', 'women', 'kid', 'unisex'];
                  final gender = _formData['gender'].toString().toLowerCase();

                  if (title.isEmpty) {
                    showError(context, 'El título no puede estar vacío');
                    return;
                  }
                  if (sizesList.isEmpty) {
                    showError(context, 'Debes ingresar al menos una talla');
                    return;
                  }
                  if (!validGenders.contains(gender)) {
                    showError(context, 'Género inválido. Usa: men, women, kid o unisex');
                    return;
                  }

                  final productData = {
                    'title': title,
                    'description': _formData['description'],
                    'price': int.tryParse(_formData['price'].toString()) ?? 0,
                    'stock': int.tryParse(_formData['stock'].toString()) ?? 0,
                    'gender': gender,
                    'sizes': sizesList,
                    'tags': tagsList,
                    'slug': slug,
                  };

                  try {
                    final imageFile = imageState.imageFile;
                    if (imageFile != null) {
                      await ProductService().createProductWithImage(productData, imageFile);
                    } else {
                      await ProductService().createProduct(productData);
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Producto creado'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    context.pop(true);
                  } catch (e) {
                    showError(context, 'Error al crear producto: $e');
                  }
                },
                child: const Text('Guardar Producto'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Widget _buildText(String key, {String? hint}) {
    return TextFormField(
      decoration: InputDecoration(labelText: key, hintText: hint),
      onSaved: (value) => _formData[key] = value?.trim() ?? '',
      validator: (value) =>
          (value == null || value.trim().isEmpty) ? 'Campo requerido' : null,
    );
  }

  Widget _buildNumber(String key) {
    return TextFormField(
      decoration: InputDecoration(labelText: key),
      keyboardType: TextInputType.number,
      onSaved: (value) => _formData[key] = value?.trim() ?? '0',
      validator: (value) {
        if (value == null || value.trim().isEmpty) return 'Campo requerido';
        final parsed = int.tryParse(value);
        if (parsed == null) return 'Debe ser un número';
        return null;
      },
    );
  }
}
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_final/products/product_service.dart';
import 'package:go_router/go_router.dart';

class ProductForm extends StatefulWidget {
  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _slugController = TextEditingController();
  String _gender = "men";
  List<String> _sizes = ["XS"];
  List<String> _tags = ["shirt"];
  File? _imageFile;

  final _picker = ImagePicker();

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  Future<void> _saveProduct() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecciona una imagen")),
      );
      return;
    }

    final productData = {
      "title": _titleController.text,
      "description": _descriptionController.text,
      "price": int.tryParse(_priceController.text) ?? 0,
      "stock": int.tryParse(_stockController.text) ?? 0,
      "gender": _gender,
      "slug": _slugController.text,
      "sizes": _sizes,
      "tags": _tags,
    };

    try {
      final service = ProductService();
      final imageName = await service.uploadProductImage(_imageFile!);
      await service.createProduct(productData, imageName);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Producto creado correctamente")),
      );

      // 👈 cerrar y devolver true para refrescar la lista
      context.pop(true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrar producto")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(controller: _titleController, decoration: InputDecoration(labelText: "Título")),
            TextField(controller: _descriptionController, decoration: InputDecoration(labelText: "Descripción")),
            TextField(controller: _priceController, decoration: InputDecoration(labelText: "Precio"), keyboardType: TextInputType.number),
            TextField(controller: _stockController, decoration: InputDecoration(labelText: "Stock"), keyboardType: TextInputType.number),
            TextField(controller: _slugController, decoration: InputDecoration(labelText: "Slug")),
            DropdownButton<String>(
              value: _gender,
              items: ["men", "women", "kid", "unisex"].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
              onChanged: (val) => setState(() => _gender = val!),
            ),
            ElevatedButton(onPressed: _pickImage, child: const Text("Seleccionar imagen")),
            if (_imageFile != null) Text("Imagen seleccionada: ${_imageFile!.path}"),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _saveProduct, child: const Text("Guardar producto")),
          ],
        ),
      ),
    );
  }
}
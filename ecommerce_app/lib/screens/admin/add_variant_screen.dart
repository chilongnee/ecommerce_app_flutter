import 'package:flutter/material.dart';
import 'package:ecommerce_app/models/product_model.dart';
import 'package:ecommerce_app/repository/product_repository.dart';

class AddVariantScreen extends StatefulWidget {
  final ProductModel parentProduct;

  const AddVariantScreen({super.key, required this.parentProduct});

  @override
  _AddVariantScreenState createState() => _AddVariantScreenState();
}

class _AddVariantScreenState extends State<AddVariantScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProductRepository _productRepo = ProductRepository();

  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _stockController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _saveVariant() async {
    if (_formKey.currentState!.validate()) {
      ProductModel newVariant = ProductModel(
        parentId: widget.parentProduct.id,
        productName: _nameController.text,
        description: widget.parentProduct.description,
        price: double.parse(_priceController.text),
        discount: 0.0,
        brand: widget.parentProduct.brand,
        categoryId: widget.parentProduct.categoryId,
        stock: int.parse(_stockController.text),
        images: [],
      );

      await _productRepo.addVariant(widget.parentProduct, newVariant);

      if (mounted) {
        Navigator.pop(context, newVariant);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thêm biến thể")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Tên biến thể"),
                validator: (value) =>
                    value!.isEmpty ? "Không được để trống" : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: "Giá"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? "Không được để trống" : null,
              ),
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: "Số lượng"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Không được để trống" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveVariant,
                child: const Text("Lưu biến thể"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

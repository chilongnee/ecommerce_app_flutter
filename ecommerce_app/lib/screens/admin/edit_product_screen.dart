import 'package:flutter/material.dart';
import 'package:ecommerce_app/models/product_model.dart';
import 'package:ecommerce_app/repository/product_repository.dart';

class EditProductScreen extends StatefulWidget {
  final ProductModel product;

  const EditProductScreen({super.key, required this.product});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProductRepository _productRepo = ProductRepository();

  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _discountController;
  late TextEditingController _stockController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.productName);
    _priceController =
        TextEditingController(text: widget.product.price.toString());
    _descriptionController =
        TextEditingController(text: widget.product.description);
    _discountController =
        TextEditingController(text: widget.product.discount.toString());
    _stockController =
        TextEditingController(text: widget.product.stock.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _discountController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      ProductModel updatedProduct = widget.product.copyWith(
        productName: _nameController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        discount: double.parse(_discountController.text),
        stock: int.parse(_stockController.text),
      );
      await _productRepo.updateProduct(updatedProduct);

      if (mounted) {
        Navigator.pop(context, updatedProduct);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chỉnh sửa sản phẩm")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Tên sản phẩm"),
                validator: (value) =>
                    value!.isEmpty ? "Không được để trống" : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Mô tả sản phẩm"),
                validator: (value) =>
                    value!.isEmpty ? "Không được để trống" : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: "Giá sản phẩm"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? "Không được để trống" : null,
              ),
              TextFormField(
                controller: _discountController,
                decoration: const InputDecoration(labelText: "Giảm giá (%)"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return "Không được để trống";
                  double discount = double.parse(value);
                  if (discount < 0 || discount > 50)
                    return "Giảm giá tối đa 50%";
                  return null;
                },
              ),
              TextFormField(
                controller: _stockController,
                decoration:
                    const InputDecoration(labelText: "Số lượng trong kho"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty || int.parse(value) < 0
                    ? "Số lượng không hợp lệ"
                    : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProduct,
                child: const Text("Lưu thay đổi"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

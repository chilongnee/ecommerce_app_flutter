import 'package:ecommerce_app/repository/category_repository.dart';
import 'package:ecommerce_app/repository/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/models/product_model.dart';
import 'package:ecommerce_app/models/category_model.dart';

class AddProductScreen extends StatefulWidget {
  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  final ProductRepository _productRepo = ProductRepository();
  final CategoryRepository _categoryRepo = CategoryRepository();

  String? _selectedCategory;
  List<CategoryModel> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final categories = await _categoryRepo.getAllCategories();
    setState(() {
      _categories = categories;
    });
  }

  void _submitProduct() async {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      final product = ProductModel(
        productName: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        brand: _brandController.text.trim(),
        categoryId: _selectedCategory!,
        stock: int.parse(_stockController.text.trim()),
        images: [_imageUrlController.text.trim()],
      );

      await _productRepo.addProduct(product);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thêm sản phẩm"),
        backgroundColor: Color(0xFF7AE582),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(_nameController, "Tên sản phẩm", Icons.shopping_bag),
                _buildTextField(_descriptionController, "Mô tả sản phẩm", Icons.description, maxLines: 3),
                _buildTextField(_priceController, "Giá sản phẩm", Icons.attach_money, keyboardType: TextInputType.number),
                _buildTextField(_brandController, "Thương hiệu", Icons.factory),
                _buildCategoryDropdown(),
                _buildTextField(_stockController, "Số lượng trong kho", Icons.inventory, keyboardType: TextInputType.number),
                _buildTextField(_imageUrlController, "URL hình ảnh", Icons.image),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7AE582),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Thêm sản phẩm",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Vui lòng nhập $label";
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: "Danh mục",
          prefixIcon: Icon(Icons.category),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        value: _selectedCategory,
        items: _categories.map((category) {
          return DropdownMenuItem(
            value: category.id,
            child: Text(category.name),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedCategory = value;
          });
        },
        validator: (value) {
          if (value == null) {
            return "Vui lòng chọn danh mục";
          }
          return null;
        },
      ),
    );
  }
}

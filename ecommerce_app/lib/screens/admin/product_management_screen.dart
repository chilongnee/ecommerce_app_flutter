import 'package:ecommerce_app/repository/category_repository.dart';
import 'package:ecommerce_app/screens/admin/add_product_screen.dart';
import 'package:ecommerce_app/screens/admin/product_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/models/category_model.dart';
import 'add_category_screen.dart';

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({super.key});

  @override
  State<ProductManagementScreen> createState() =>
      _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  final CategoryRepository _categoryRepo = CategoryRepository();
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

  void _navigateToAddCategory() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddCategoryScreen()),
    );
    _loadCategories();
  }

  void _navigateToAddProduct() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddProductScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý danh mục"),
        backgroundColor: Colors.green,
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == "add_category") {
                _navigateToAddCategory();
              } else if (value == "add_product") {
                _navigateToAddProduct();
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: "add_category",
                child: Text("Thêm danh mục"),
              ),
              const PopupMenuItem(
                value: "add_product",
                child: Text("Thêm sản phẩm"),
              ),
            ],
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _categories.isEmpty
          ? const Center(child: Text("Chưa có danh mục nào"))
          : ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return ListTile(
                  leading: category.imageUrl != null &&
                          category.imageUrl!.isNotEmpty
                      ? Image.network(category.imageUrl!,
                          width: 50, height: 50, fit: BoxFit.cover)
                      : const Icon(Icons.folder, size: 50, color: Colors.grey),
                  title: Text(category.name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductListScreen(
                            categoryId: category.id!,
                            categoryName: category.name),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

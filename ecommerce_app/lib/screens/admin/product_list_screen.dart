import 'package:ecommerce_app/screens/admin/edit_product_screen.dart';
import 'package:ecommerce_app/screens/admin/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ecommerce_app/models/product_model.dart';
import 'package:ecommerce_app/repository/product_repository.dart';

class ProductListScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const ProductListScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductRepository _productRepo = ProductRepository();
  List<ProductModel> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final products =
        await _productRepo.getProductsByCategory(widget.categoryId);
    setState(() {
      _products = products;
    });
  }

  void _editProduct(ProductModel product) async {
    final updatedProduct = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductScreen(product: product),
      ),
    );

    if (updatedProduct != null) {
      setState(() {
        final index = _products.indexWhere((p) => p.id == updatedProduct.id);
        if (index != -1) {
          _products[index] = updatedProduct;
        }
      });
    }
  }

  void _deleteProduct(ProductModel product) async {
    bool? confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xác nhận xóa"),
        content: Text("Bạn có chắc muốn xóa '${product.productName}' không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context, true);
              await _productRepo.deleteProduct(product.id!);
              setState(() {
                _products.removeWhere((p) => p.id == product.id);
              });
            },
            child: const Text("Xóa", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sản phẩm - ${widget.categoryName}"),
        backgroundColor: Colors.green,
      ),
      body: _products.isEmpty
          ? const Center(child: Text("Không có sản phẩm nào"))
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];

                return Slidable(
                  key: Key(product.id ?? ""),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    extentRatio: 0.3,
                    children: [
                      SlidableAction(
                        onPressed: (context) => _editProduct(product),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Sửa',
                      ),
                      SlidableAction(
                        onPressed: (context) => _deleteProduct(product),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Xóa',
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: product.images.isNotEmpty &&
                            product.images.first.isNotEmpty
                        ? Image.network(product.images.first,
                            width: 50, height: 50, fit: BoxFit.cover)
                        : const Icon(Icons.laptop,
                            size: 50, color: Colors.grey),
                    title: Text(product.productName),
                    subtitle: Text("Giá: ${product.price} đ"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailScreen(product: product),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

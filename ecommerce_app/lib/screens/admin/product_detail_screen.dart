import 'package:ecommerce_app/repository/product_repository.dart';
import 'package:ecommerce_app/screens/admin/add_variant_screen.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/models/product_model.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductRepository _productRepo = ProductRepository();
  late List<ProductModel> variants = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVariants();
  }

  void _loadVariants() async {
    setState(() => isLoading = true);

    if (widget.product.id != null) {
      variants = await _productRepo.getVariants(widget.product.id!);
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.productName),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: widget.product.images.isNotEmpty &&
                      widget.product.images.first.isNotEmpty
                  ? Image.network(widget.product.images.first,
                      height: 200, fit: BoxFit.cover)
                  : const Icon(Icons.laptop, size: 200, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            Text(
              widget.product.productName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Giá: ${widget.product.price} đ",
              style: const TextStyle(fontSize: 18, color: Colors.red),
            ),
            const SizedBox(height: 10),
            Text(
              "Mô tả: ${widget.product.description ?? 'Không có mô tả'}",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (variants.isNotEmpty) ...[
              const Text(
                "Biến thể sản phẩm:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: variants.length,
                itemBuilder: (context, index) {
                  final variant = variants[index];
                  return Card(
                    child: ListTile(
                      leading: variant.images.isNotEmpty &&
                              variant.images.first.isNotEmpty
                          ? Image.network(variant.images.first,
                              width: 50, height: 50)
                          : const Icon(Icons.image,
                              size: 50, color: Colors.grey),
                      title: Text(variant.productName),
                      subtitle: Text("Giá: ${variant.price} đ"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailScreen(product: variant),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ] else ...[
              const Text(
                "Sản phẩm này không có biến thể.",
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ],

            const SizedBox(height: 20),
            if (widget.product.parentId == null)
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final newVariant = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddVariantScreen(parentProduct: widget.product),
                      ),
                    );

                    if (newVariant != null) {
                      _loadVariants();
                    }
                  },
                  child: const Text("Thêm biến thể"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:ecommerce_app/screens/admin/product_management_screen.dart';
import 'package:flutter/material.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trang Admin"),
        backgroundColor: Color(0xFF7AE582),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildAdminCard(
              icon: Icons.shopping_cart,
              label: "Sản phẩm",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProductManagementScreen()),
                );
              },
            ),
            _buildAdminCard(
              icon: Icons.category,
              label: "Danh mục",
              onTap: () {
                // quản lý danh mục
              },
            ),
            _buildAdminCard(
              icon: Icons.shopping_bag,
              label: "Đơn hàng",
              onTap: () {
                // quản lý đơn hàng
              },
            ),
            _buildAdminCard(
              icon: Icons.person,
              label: "Người dùng",
              onTap: () {
                // quản lý người dùng
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.green),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

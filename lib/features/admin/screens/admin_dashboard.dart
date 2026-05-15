import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/admin_provider.dart';
import '../../../providers/auth_provider.dart';
import 'admin_orders_screen.dart';
import 'admin_products_screen.dart';
import 'admin_cats_screen.dart';

import 'admin_add_product_screen.dart';
import 'admin_add_cat_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final admin = Provider.of<AdminProvider>(context);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: AppColors.deepBrown,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              auth.logout();
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Business Overview',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepBrown),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildStatCard(
                  context,
                  'Total Revenue',
                  '\$${admin.totalRevenue.toStringAsFixed(2)}',
                  Icons.monetization_on,
                  Colors.green,
                ),
                const SizedBox(width: 16),
                _buildStatCard(
                  context,
                  'Total Orders',
                  '${admin.allOrders.length}',
                  Icons.shopping_bag,
                  Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatCard(
                  context,
                  'Pending Orders',
                  '${admin.pendingOrdersCount}',
                  Icons.pending_actions,
                  Colors.orange,
                ),
                const SizedBox(width: 16),
                _buildStatCard(
                  context,
                  'Products',
                  '${admin.allProducts.length}',
                  Icons.coffee,
                  AppColors.deepBrown,
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Quick Actions',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepBrown),
            ),
            const SizedBox(height: 16),
            _buildActionTile(context, 'Manage Orders', Icons.receipt_long, () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AdminOrdersScreen()));
            }),
            _buildActionTile(context, 'Manage Inventory', Icons.inventory, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const AdminProductsScreen()));
            }),
            _buildActionTile(context, 'Manage Cats', Icons.pets, () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AdminCatsScreen()));
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.deepBrown,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading:
                        const Icon(Icons.coffee, color: AppColors.deepBrown),
                    title: const Text('Add New Product'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AdminAddProductScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.pets, color: AppColors.deepBrown),
                    title: const Text('Add New Cat'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AdminAddCatScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value,
      IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 12),
            Text(value,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(title,
                style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: AppColors.deepBrown),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

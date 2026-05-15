import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/product_model.dart';
import '../../../providers/admin_provider.dart';
import '../../../widgets/app_image.dart';
import 'admin_add_product_screen.dart';
import '../../../providers/auth_provider.dart';

class AdminProductsScreen extends StatelessWidget {
  const AdminProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final admin = Provider.of<AdminProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showProductForm(context),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: admin.allProducts.length,
        itemBuilder: (context, index) {
          final product = admin.allProducts[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: AppImage(
                imageUrl: product.imageUrl,
                width: 50,
                height: 50,
                borderRadius: BorderRadius.circular(8),
                fit: BoxFit.cover,
              ),
              title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${product.category} - \$${product.price.toStringAsFixed(2)}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _showProductForm(context, product: product),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => admin.deleteProduct(product.id, product.imageUrl),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showProductForm(BuildContext context, {ProductModel? product}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdminAddProductScreen(product: product)),
    );
  }
}

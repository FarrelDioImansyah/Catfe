import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/product_provider.dart';
import '../../../widgets/product_card.dart';
import '../../../widgets/cart_badge.dart';
import '../../../widgets/profile_button.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final categories = ['All', 'Coffee', 'Tea', 'Snack', 'Pastry'];

    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Menu'),
          actions: const [
            CartBadge(),
            Padding(
              padding: EdgeInsets.only(right: 16, left: 8),
              child: ProfileButton(),
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: AppColors.cream,
            labelColor: AppColors.cream,
            unselectedLabelColor: AppColors.pastelPeach,
            tabs: categories.map((cat) => Tab(text: cat)).toList(),
          ),
        ),
        body: TabBarView(
          children: categories.map((category) {
            final filteredProducts = productProvider.getProductsByCategory(category);
            
            if (filteredProducts.isEmpty) {
              return const Center(child: Text('No products found in this category.'));
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return ProductCard(product: product);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

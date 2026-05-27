import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/product_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/cart_provider.dart';
import '../../../widgets/app_image.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String _selectedIce = 'Normal Ice';
  String _selectedSugar = 'Normal Sugar';
  String _selectedSize = 'Regular Cup';

  final List<String> _iceLevels = ['Less Ice', 'Normal Ice', 'Warm'];
  final List<String> _sugarLevels = ['Less Sugar', 'Normal Sugar', 'Extra Sugar'];
  final List<String> _sizes = ['Regular Cup', 'Large Bottle'];

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.3), shape: BoxShape.circle),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Column(
        children: [
          Hero(
            tag: 'product-${widget.product.id}',
            child: AppImage(
              imageUrl: widget.product.imageUrl,
              height: MediaQuery.of(context).size.height * 0.40,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.product.category,
                          style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                        const Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 20),
                            SizedBox(width: 4),
                            Text('4.8', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.product.name,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.deepBrown),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Description',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.deepBrown),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.product.description,
                      style: const TextStyle(color: Colors.grey, height: 1.5),
                    ),
                    
                    if (widget.product.isDrink) ...[
                      const SizedBox(height: 20),
                      const Text(
                        'Ice Level',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.deepBrown),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: _iceLevels.map((level) {
                          final isSelected = _selectedIce == level;
                          return ChoiceChip(
                            label: Text(level),
                            selected: isSelected,
                            selectedColor: AppColors.pastelPeach,
                            backgroundColor: Colors.grey[200],
                            labelStyle: TextStyle(
                              color: isSelected ? AppColors.deepBrown : Colors.grey[800],
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            onSelected: (selected) {
                              if (selected) {
                                setState(() => _selectedIce = level);
                              }
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Sugar Level',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.deepBrown),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: _sugarLevels.map((level) {
                          final isSelected = _selectedSugar == level;
                          return ChoiceChip(
                            label: Text(level),
                            selected: isSelected,
                            selectedColor: AppColors.pastelPeach,
                            backgroundColor: Colors.grey[200],
                            labelStyle: TextStyle(
                              color: isSelected ? AppColors.deepBrown : Colors.grey[800],
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            onSelected: (selected) {
                              if (selected) {
                                setState(() => _selectedSugar = level);
                              }
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Size',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.deepBrown),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: _sizes.map((level) {
                          final isSelected = _selectedSize == level;
                          return ChoiceChip(
                            label: Text(level),
                            selected: isSelected,
                            selectedColor: AppColors.pastelPeach,
                            backgroundColor: Colors.grey[200],
                            labelStyle: TextStyle(
                              color: isSelected ? AppColors.deepBrown : Colors.grey[800],
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            onSelected: (selected) {
                              if (selected) {
                                setState(() => _selectedSize = level);
                              }
                            },
                          );
                        }).toList(),
                      ),
                    ],
                    
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Price', style: TextStyle(color: Colors.grey)),
                            Text(
                              '\$${widget.product.price.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.deepBrown),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            cartProvider.addToCart(
                              widget.product,
                              iceLevel: widget.product.isDrink ? _selectedIce : null,
                              sugarLevel: widget.product.isDrink ? _selectedSugar : null,
                              size: widget.product.isDrink ? _selectedSize : null,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${widget.product.name} added to cart!'),
                                duration: const Duration(seconds: 1),
                                behavior: SnackBarBehavior.floating,
                              )
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            backgroundColor: AppColors.deepBrown,
                          ),
                          icon: const Icon(Icons.shopping_bag_outlined),
                          label: const Text('Add to Cart'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

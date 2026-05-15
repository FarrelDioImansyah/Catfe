import 'package:hive_flutter/hive_flutter.dart';
import '../models/product_model.dart';

class ProductService {
  final Box _productBox = Hive.box('products');

  ProductService() {
    _seedData();
  }

  // Initial seed data for local testing
  void _seedData() {
    if (_productBox.isEmpty) {
      final initialProducts = [
        ProductModel(
          id: 'p1',
          name: 'Classic Latte',
          description: 'Smooth espresso with steamed milk.',
          price: 4.50,
          category: 'Coffee',
          imageUrl: 'https://images.unsplash.com/photo-1570968915860-54d5c301fa9f?w=500',
          isBestSeller: true,
        ),
        ProductModel(
          id: 'p2',
          name: 'Matcha Green Tea',
          description: 'Premium ceremonial grade matcha.',
          price: 5.00,
          category: 'Tea',
          imageUrl: 'https://images.unsplash.com/photo-1515823064-d6e0c04616a7?w=500',
          isPromo: true,
        ),
        ProductModel(
          id: 'p3',
          name: 'Croissant',
          description: 'Buttery, flaky french pastry.',
          price: 3.50,
          category: 'Pastry',
          imageUrl: 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=500',
        ),
      ];

      for (var p in initialProducts) {
        _productBox.put(p.id, p.toMap());
      }
    }
  }

  // Get all products
  List<ProductModel> getAllProducts() {
    return _productBox.values
        .map((e) => ProductModel.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  // Stream for real-time updates (Simulated with Hive listenable)
  Stream<List<ProductModel>> streamProducts() {
    return _productBox.watch().map((event) => getAllProducts());
  }

  // Admin CRUD
  Future<void> addProduct(ProductModel product) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    await _productBox.put(id, product.copyWith(id: id).toMap());
  }

  Future<void> updateProduct(ProductModel product) async {
    await _productBox.put(product.id, product.toMap());
  }

  Future<void> deleteProduct(String id) async {
    await _productBox.delete(id);
  }
}

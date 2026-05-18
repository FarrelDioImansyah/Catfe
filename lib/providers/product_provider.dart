import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();
  List<ProductModel> _products = [];
  bool _isLoading = false;

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;

  List<ProductModel> get bestSellers =>
      _products.where((p) => p.isBestSeller).toList();
  List<ProductModel> get promoProducts =>
      _products.where((p) => p.isPromo).toList();

  ProductProvider() {
    _init();
  }

  void _init() {
    _isLoading = true;
    _products = _productService.getAllProducts();
    _isLoading = false;
    notifyListeners();

    // Listen for local changes
    _productService.streamProducts().listen((updatedProducts) {
      _products = updatedProducts;
      notifyListeners();
    });
  }

  List<ProductModel> getProductsByCategory(String category) {
    if (category == 'All') return _products;
    return _products.where((p) => p.category == category).toList();
  }
}

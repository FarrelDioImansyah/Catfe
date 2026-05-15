import 'dart:io';
import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../models/cat_model.dart';
import '../services/product_service.dart';
import '../services/cat_service.dart';
import '../services/order_service.dart';

class AdminProvider with ChangeNotifier {
  final ProductService _productService = ProductService();
  final CatService _catService = CatService();
  final OrderService _orderService = OrderService();

  List<OrderModel> _allOrders = [];
  List<ProductModel> _allProducts = [];
  List<CatModel> _allCats = [];
  bool _isLoading = false;

  List<OrderModel> get allOrders => _allOrders;
  List<ProductModel> get allProducts => _allProducts;
  List<CatModel> get allCats => _allCats;
  bool get isLoading => _isLoading;

  double get totalRevenue => _allOrders
      .where((o) => o.status == OrderStatus.completed)
      .fold(0, (sum, item) => sum + item.totalAmount);

  int get pendingOrdersCount => _allOrders.where((o) => o.status == OrderStatus.pending).length;

  AdminProvider() {
    _init();
  }

  void _init() {
    _refreshData();
    
    // In local mode, we refresh whenever the services indicate a change
    // For simplicity, we just pull the latest from Hive
    _productService.streamProducts().listen((_) => _refreshData());
    _catService.streamCats().listen((_) => _refreshData());
  }

  void _refreshData() {
    _allProducts = _productService.getAllProducts();
    _allCats = _catService.getAllCats();
    _allOrders = _orderService.getAllOrders();
    notifyListeners();
  }

  // ORDER ACTIONS
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    await _orderService.updateOrderStatus(orderId, status);
    _refreshData();
  }

  // PRODUCT ACTIONS
  Future<void> saveProduct(ProductModel product, File? imageFile) async {
    _isLoading = true;
    notifyListeners();

    try {
      String imageUrl = product.imageUrl;
      if (imageFile != null) {
        // In local mode, we'd copy the file to app docs. 
        // For now, we'll use the local path as the URL.
        imageUrl = imageFile.path; 
      }

      if (product.id.isEmpty) {
        await _productService.addProduct(product.copyWith(imageUrl: imageUrl));
      } else {
        await _productService.updateProduct(product.copyWith(imageUrl: imageUrl));
      }
    } finally {
      _isLoading = false;
      _refreshData();
    }
  }

  Future<void> deleteProduct(String id, String imageUrl) async {
    await _productService.deleteProduct(id);
    _refreshData();
  }

  // CAT ACTIONS
  Future<void> saveCat(CatModel cat, File? imageFile) async {
    _isLoading = true;
    notifyListeners();

    try {
      String imageUrl = cat.imageUrl;
      if (imageFile != null) {
        imageUrl = imageFile.path;
      }

      if (cat.id.isEmpty) {
        await _catService.addCat(cat.copyWith(imageUrl: imageUrl));
      } else {
        await _catService.updateCat(cat.copyWith(imageUrl: imageUrl));
      }
    } finally {
      _isLoading = false;
      _refreshData();
    }
  }

  Future<void> deleteCat(String id, String imageUrl) async {
    await _catService.deleteCat(id);
    _refreshData();
  }
}

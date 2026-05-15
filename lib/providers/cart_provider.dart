import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import '../services/cart_service.dart';

class CartProvider with ChangeNotifier {
  final CartService _cartService = CartService();
  final List<CartItemModel> _items = [];
  String? _currentUserId;

  List<CartItemModel> get items => _items;

  int get itemCount => _items.length;

  double get totalAmount {
    double total = 0.0;
    for (var item in _items) {
      total += item.totalPrice;
    }
    return total;
  }

  // Load cart when user logs in
  void update(String? userId) {
    if (_currentUserId == userId) return;
    
    _currentUserId = userId;
    _items.clear();
    if (userId != null) {
      _items.addAll(_cartService.getCartItems(userId));
    }
    notifyListeners();
  }

  void addToCart(ProductModel product) {
    int index = _items.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(
        CartItemModel(
          id: DateTime.now().toString(),
          product: product,
        ),
      );
    }
    _persist();
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    _persist();
    notifyListeners();
  }

  void incrementQuantity(String productId) {
    int index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index].quantity++;
      _persist();
      notifyListeners();
    }
  }

  void decrementQuantity(String productId) {
    int index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      _persist();
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    if (_currentUserId != null) {
      _cartService.clearCart(_currentUserId!);
    }
    notifyListeners();
  }

  void _persist() {
    if (_currentUserId != null) {
      _cartService.saveCartItems(_currentUserId!, _items);
    }
  }
}

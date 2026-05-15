import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/cart_item_model.dart';
import '../services/order_service.dart';

class OrderProvider with ChangeNotifier {
  final OrderService _orderService = OrderService();
  List<OrderModel> _userOrders = [];
  bool _isLoading = false;

  List<OrderModel> get userOrders => _userOrders;
  bool get isLoading => _isLoading;

  String? _currentUserId;

  void update(String? userId) {
    if (_currentUserId == userId) return;
    _currentUserId = userId;
    if (userId != null) {
      fetchUserOrders(userId);
    } else {
      _userOrders = [];
      notifyListeners();
    }
  }

  void fetchUserOrders(String userId) {
    _userOrders = _orderService.getUserOrders(userId);
    notifyListeners();

    _orderService.streamUserOrders(userId).listen((updatedOrders) {
      _userOrders = updatedOrders;
      notifyListeners();
    });
  }

  Future<void> placeOrder({
    required String userId,
    required List<CartItemModel> items,
    required double totalAmount,
    required String tableNumber,
  }) async {
    _isLoading = true;
    notifyListeners();

    final order = OrderModel(
      id: '', // Will be generated in service
      userId: userId,
      items: items,
      totalAmount: totalAmount,
      status: OrderStatus.pending,
      tableNumber: tableNumber,
      createdAt: DateTime.now(),
    );

    await _orderService.placeOrder(order);
    
    _isLoading = false;
    notifyListeners();
  }
}

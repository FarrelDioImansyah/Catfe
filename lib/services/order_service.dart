import 'package:hive_flutter/hive_flutter.dart';
import '../models/order_model.dart';

class OrderService {
  final Box _orderBox = Hive.box('orders');

  // Place a new order
  Future<void> placeOrder(OrderModel order) async {
    final id = 'ORD-${DateTime.now().millisecondsSinceEpoch}';
    await _orderBox.put(id, order.copyWith(id: id).toMap());
  }

  // Get orders for a specific user
  List<OrderModel> getUserOrders(String userId) {
    return _orderBox.values
        .map((e) => OrderModel.fromMap(Map<String, dynamic>.from(e)))
        .where((o) => o.userId == userId)
        .toList();
  }

  // Stream user orders
  Stream<List<OrderModel>> streamUserOrders(String userId) {
    return _orderBox.watch().map((event) => getUserOrders(userId));
  }

  // Admin: Get all orders
  List<OrderModel> getAllOrders() {
    return _orderBox.values
        .map((e) => OrderModel.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  // Admin: Update order status
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    final data = _orderBox.get(orderId);
    if (data != null) {
      final order = OrderModel.fromMap(Map<String, dynamic>.from(data));
      await _orderBox.put(orderId, order.copyWith(status: status).toMap());
    }
  }
}

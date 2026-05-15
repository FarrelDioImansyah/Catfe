import 'package:hive_flutter/hive_flutter.dart';
import '../models/cart_item_model.dart';

class CartService {
  final Box _settingsBox = Hive.box('settings');

  // Fetch cart items for a user (Local)
  List<CartItemModel> getCartItems(String userId) {
    final List<dynamic>? rawItems = _settingsBox.get('cart_$userId');
    if (rawItems == null) return [];
    
    return rawItems
        .map((e) => CartItemModel.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> saveCartItems(String userId, List<CartItemModel> items) async {
    final data = items.map((e) => e.toMap()).toList();
    await _settingsBox.put('cart_$userId', data);
  }

  Future<void> clearCart(String userId) async {
    await _settingsBox.delete('cart_$userId');
  }
}

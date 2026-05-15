import 'cart_item_model.dart';

enum OrderStatus { pending, approved, preparing, completed, cancelled }

class OrderModel {
  final String id;
  final String userId;
  final List<CartItemModel> items;
  final double totalAmount;
  final DateTime createdAt;
  final OrderStatus status;
  final String tableNumber; // Add this

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.createdAt,
    this.status = OrderStatus.pending,
    required this.tableNumber, // Add this
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'createdAt': createdAt.toIso8601String(),
      'status': status.name,
      'tableNumber': tableNumber,
    };
  }

  factory OrderModel.fromMap(Map<dynamic, dynamic> map) {
    return OrderModel(
      id: map['id']?.toString() ?? '',
      userId: map['userId']?.toString() ?? '',
      items: (map['items'] as List?)
              ?.map((item) => CartItemModel.fromMap(item as Map))
              .toList() ??
          [],
      totalAmount: (map['totalAmount'] ?? 0.0).toDouble(),
      createdAt: DateTime.parse(map['createdAt']?.toString() ?? DateTime.now().toIso8601String()),
      status: OrderStatus.values.byName(map['status']?.toString() ?? 'pending'),
      tableNumber: map['tableNumber']?.toString() ?? 'N/A',
    );
  }

  OrderModel copyWith({
    String? id,
    String? userId,
    List<CartItemModel>? items,
    double? totalAmount,
    DateTime? createdAt,
    OrderStatus? status,
    String? tableNumber,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      tableNumber: tableNumber ?? this.tableNumber,
    );
  }
}

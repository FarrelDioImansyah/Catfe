import 'product_model.dart';

class CartItemModel {
  final String id;
  final ProductModel product;
  int quantity;
  final String? iceLevel;
  final String? sugarLevel;
  final String? size;

  CartItemModel({
    required this.id,
    required this.product,
    this.quantity = 1,
    this.iceLevel,
    this.sugarLevel,
    this.size,
  });

  double get totalPrice => product.price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product': product.toMap(),
      'quantity': quantity,
      'iceLevel': iceLevel,
      'sugarLevel': sugarLevel,
      'size': size,
    };
  }

  factory CartItemModel.fromMap(Map<dynamic, dynamic> map) {
    return CartItemModel(
      id: map['id']?.toString() ?? '',
      product: ProductModel.fromMap(map['product'] as Map),
      quantity: map['quantity'] ?? 1,
      iceLevel: map['iceLevel']?.toString(),
      sugarLevel: map['sugarLevel']?.toString(),
      size: map['size']?.toString(),
    );
  }

  CartItemModel copyWith({
    String? id,
    ProductModel? product,
    int? quantity,
    String? iceLevel,
    String? sugarLevel,
    String? size,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      iceLevel: iceLevel ?? this.iceLevel,
      sugarLevel: sugarLevel ?? this.sugarLevel,
      size: size ?? this.size,
    );
  }
}

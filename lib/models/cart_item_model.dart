import 'product_model.dart';

class CartItemModel {
  final String id;
  final ProductModel product;
  int quantity;

  CartItemModel({
    required this.id,
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product': product.toMap(),
      'quantity': quantity,
    };
  }

  factory CartItemModel.fromMap(Map<dynamic, dynamic> map) {
    return CartItemModel(
      id: map['id']?.toString() ?? '',
      product: ProductModel.fromMap(map['product'] as Map),
      quantity: map['quantity'] ?? 1,
    );
  }

  CartItemModel copyWith({
    String? id,
    ProductModel? product,
    int? quantity,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}

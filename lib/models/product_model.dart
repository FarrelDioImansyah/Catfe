class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category; // e.g., 'Coffee', 'Tea', 'Snack'
  final bool isBestSeller;
  final bool isPromo;
  final double? discountPrice;

  bool get isDrink => category.toLowerCase() == 'coffee' || category.toLowerCase() == 'tea';

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.isBestSeller = false,
    this.isPromo = false,
    this.discountPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'isBestSeller': isBestSeller,
      'isPromo': isPromo,
      'discountPrice': discountPrice,
    };
  }

  factory ProductModel.fromMap(Map<dynamic, dynamic> map) {
    return ProductModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      imageUrl: map['imageUrl']?.toString() ?? '',
      category: map['category']?.toString() ?? '',
      isBestSeller: map['isBestSeller'] ?? false,
      isPromo: map['isPromo'] ?? false,
      discountPrice: map['discountPrice']?.toDouble(),
    );
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    bool? isBestSeller,
    bool? isPromo,
    double? discountPrice,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      isBestSeller: isBestSeller ?? this.isBestSeller,
      isPromo: isPromo ?? this.isPromo,
      discountPrice: discountPrice ?? this.discountPrice,
    );
  }
}

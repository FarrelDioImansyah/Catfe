import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService {
  final CollectionReference _productCollection =
      FirebaseFirestore.instance.collection('products');

  List<ProductModel> _cachedProducts = [];

  ProductService() {
    // Dengarkan stream secara realtime untuk meng-update cache lokal
    streamProducts().listen((products) {
      _cachedProducts = products;
      // Otomatis seed data ke cloud jika database kosong
      if (products.isEmpty) {
        _seedData();
      }
    });
  }

  // Pengisian data awal ke Firestore jika database kosong
  void _seedData() {
    final initialProducts = [
      ProductModel(
        id: '',
        name: 'Classic Latte',
        description: 'Smooth espresso with steamed milk.',
        price: 4.50,
        category: 'Coffee',
        imageUrl:
            'https://images.unsplash.com/photo-1570968915860-54d5c301fa9f?w=500',
        isBestSeller: true,
      ),
      ProductModel(
        id: '',
        name: 'Matcha Green Tea',
        description: 'Premium ceremonial grade matcha.',
        price: 5.00,
        category: 'Tea',
        imageUrl:
            'https://images.unsplash.com/photo-1515823064-d6e0c04616a7?w=500',
        isPromo: true,
      ),
      ProductModel(
        id: '',
        name: 'Croissant',
        description: 'Buttery, flaky french pastry.',
        price: 3.50,
        category: 'Pastry',
        imageUrl:
            'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=500',
      ),
    ];

    for (var p in initialProducts) {
      addProduct(p);
    }
  }

  // Get all products (Mengambil dari cache lokal secara sinkron untuk menghindari delay UI)
  List<ProductModel> getAllProducts() {
    return _cachedProducts;
  }

  // Stream realtime dari Cloud Firestore
  Stream<List<ProductModel>> streamProducts() {
    return _productCollection.snapshots().map((snapshot) {
      final products = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        // Pakai ID Dokumen Firestore sebagai ID produk
        return ProductModel.fromMap(data).copyWith(id: doc.id);
      }).toList();
      _cachedProducts = products;
      return products;
    });
  }

  // Admin CRUD
  Future<void> addProduct(ProductModel product) async {
    await _productCollection.add(product.toMap());
  }

  Future<void> updateProduct(ProductModel product) async {
    await _productCollection.doc(product.id).update(product.toMap());
  }

  Future<void> deleteProduct(String id) async {
    await _productCollection.doc(id).delete();
  }
}


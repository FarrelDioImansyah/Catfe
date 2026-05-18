import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

class OrderService {
  final CollectionReference _orderCollection =
      FirebaseFirestore.instance.collection('orders');

  List<OrderModel> _cachedOrders = [];

  OrderService() {
    // Dengarkan stream global pesanan secara realtime untuk sinkronisasi admin & customer
    _orderCollection.snapshots().listen((snapshot) {
      _cachedOrders = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return OrderModel.fromMap(data).copyWith(id: doc.id);
      }).toList();
    });
  }

  // Buat/kirim pesanan baru ke Cloud Firestore
  Future<void> placeOrder(OrderModel order) async {
    // Kita buat ID pesanan yang unik dengan format ORD-timestamp
    final id = 'ORD-${DateTime.now().millisecondsSinceEpoch}';
    final orderWithId = order.copyWith(id: id);
    // Simpan ke Firestore dengan ID dokumen ORD-timestamp agar mudah dicari
    await _orderCollection.doc(id).set(orderWithId.toMap());
  }

  // Dapatkan riwayat pesanan user tertentu (dari cache lokal untuk performa cepat)
  List<OrderModel> getUserOrders(String userId) {
    return _cachedOrders.where((o) => o.userId == userId).toList();
  }

  // Stream pesanan user secara realtime dari Firestore (untuk live order status tracking)
  Stream<List<OrderModel>> streamUserOrders(String userId) {
    return _orderCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return OrderModel.fromMap(data).copyWith(id: doc.id);
      }).toList();
    });
  }

  // Admin: Stream semua pesanan secara realtime dari Firestore
  Stream<List<OrderModel>> streamAllOrders() {
    return _orderCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return OrderModel.fromMap(data).copyWith(id: doc.id);
      }).toList();
    });
  }

  // Admin: Mengambil semua daftar pesanan
  List<OrderModel> getAllOrders() {
    return _cachedOrders;
  }

  // Admin: Update status pesanan secara realtime
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    await _orderCollection.doc(orderId).update({'status': status.name});
  }
}


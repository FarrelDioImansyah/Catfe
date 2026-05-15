import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/order_provider.dart';
import '../../../widgets/order_card.dart';
import '../../../widgets/cart_badge.dart';
import '../../../widgets/profile_button.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch orders for current user on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = Provider.of<AuthProvider>(context, listen: false).userModel?.uid;
      if (userId != null) {
        Provider.of<OrderProvider>(context, listen: false).fetchUserOrders(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        actions: const [
          CartBadge(),
          Padding(
            padding: EdgeInsets.only(right: 16, left: 8),
            child: ProfileButton(),
          ),
        ],
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.deepBrown,
        elevation: 0,
      ),
      body: orderProvider.userOrders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text('No orders yet', style: TextStyle(color: Colors.grey, fontSize: 18)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orderProvider.userOrders.length,
              itemBuilder: (context, index) {
                return OrderCard(order: orderProvider.userOrders[index]);
              },
            ),
    );
  }
}

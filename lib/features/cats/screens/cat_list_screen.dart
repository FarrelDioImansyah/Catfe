import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/cat_provider.dart';
import '../../../widgets/cat_card.dart';
import '../../../widgets/cart_badge.dart';
import '../../../widgets/profile_button.dart';

class CatListScreen extends StatelessWidget {
  const CatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final catProvider = Provider.of<CatProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Resident Cats'),
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
      body: catProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : catProvider.cats.isEmpty
              ? const Center(child: Text('No cats found. They might be taking a nap!'))
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: catProvider.cats.length,
                  itemBuilder: (context, index) {
                    return CatCard(cat: catProvider.cats[index]);
                  },
                ),
    );
  }
}

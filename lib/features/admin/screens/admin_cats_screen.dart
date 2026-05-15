import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/cat_model.dart';
import '../../../providers/admin_provider.dart';
import '../../../widgets/app_image.dart';
import 'admin_add_cat_screen.dart';
import '../../../providers/auth_provider.dart';

class AdminCatsScreen extends StatelessWidget {
  const AdminCatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final admin = Provider.of<AdminProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Cats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCatForm(context),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: admin.allCats.length,
        itemBuilder: (context, index) {
          final cat = admin.allCats[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: SizedBox(
                width: 40,
                height: 40,
                child: AppImage(
                  imageUrl: cat.imageUrl,
                  borderRadius: BorderRadius.circular(20),
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(cat.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${cat.breed} - ${cat.personality}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _showCatForm(context, cat: cat),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => admin.deleteCat(cat.id, cat.imageUrl),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showCatForm(BuildContext context, {CatModel? cat}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdminAddCatScreen(cat: cat)),
    );
  }
}

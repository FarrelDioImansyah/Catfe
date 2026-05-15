import 'package:hive_flutter/hive_flutter.dart';
import '../models/cat_model.dart';

class CatService {
  final Box _catBox = Hive.box('cats');

  CatService() {
    _seedData();
  }

  void _seedData() {
    if (_catBox.isEmpty) {
      final initialCats = [
        CatModel(
          id: 'c1',
          name: 'Mochi',
          breed: 'Calico',
          age: 2,
          description: 'A very sweet and lazy calico who loves chin scratches.',
          personality: 'Sleepy & Sweet',
          imageUrl: 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=500',
        ),
        CatModel(
          id: 'c2',
          name: 'Cookie',
          breed: 'Scottish Fold',
          age: 1,
          description: 'Full of energy and loves chasing laser pointers.',
          personality: 'Energetic',
          imageUrl: 'https://images.unsplash.com/photo-1574158622682-e40e69881006?w=500',
        ),
      ];

      for (var c in initialCats) {
        _catBox.put(c.id, c.toMap());
      }
    }
  }

  List<CatModel> getAllCats() {
    return _catBox.values
        .map((e) => CatModel.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  Stream<List<CatModel>> streamCats() {
    return _catBox.watch().map((event) => getAllCats());
  }

  // Admin CRUD
  Future<void> addCat(CatModel cat) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    await _catBox.put(id, cat.copyWith(id: id).toMap());
  }

  Future<void> updateCat(CatModel cat) async {
    await _catBox.put(cat.id, cat.toMap());
  }

  Future<void> deleteCat(String id) async {
    await _catBox.delete(id);
  }
}

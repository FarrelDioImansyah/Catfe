import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cat_model.dart';

class CatService {
  final CollectionReference _catCollection =
      FirebaseFirestore.instance.collection('cats');

  List<CatModel> _cachedCats = [];

  CatService() {
    // Dengarkan stream secara realtime untuk meng-update cache lokal
    streamCats().listen((cats) {
      _cachedCats = cats;
      // Otomatis seed data kucing jika cloud database kosong
      if (cats.isEmpty) {
        _seedData();
      }
    });
  }

  void _seedData() {
    final initialCats = [
      CatModel(
        id: '',
        name: 'Mochi',
        breed: 'Calico',
        age: 2,
        description: 'A very sweet and lazy calico who loves chin scratches.',
        personality: 'Sleepy & Sweet',
        imageUrl:
            'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=500',
      ),
      CatModel(
        id: '',
        name: 'Cookie',
        breed: 'Scottish Fold',
        age: 1,
        description: 'Full of energy and loves chasing laser pointers.',
        personality: 'Energetic',
        imageUrl:
            'https://images.unsplash.com/photo-1574158622682-e40e69881006?w=500',
      ),
    ];

    for (var c in initialCats) {
      addCat(c);
    }
  }

  List<CatModel> getAllCats() {
    return _cachedCats;
  }

  Stream<List<CatModel>> streamCats() {
    return _catCollection.snapshots().map((snapshot) {
      final cats = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return CatModel.fromMap(data).copyWith(id: doc.id);
      }).toList();
      _cachedCats = cats;
      return cats;
    });
  }

  // Admin CRUD
  Future<void> addCat(CatModel cat) async {
    await _catCollection.add(cat.toMap());
  }

  Future<void> updateCat(CatModel cat) async {
    await _catCollection.doc(cat.id).update(cat.toMap());
  }

  Future<void> deleteCat(String id) async {
    await _catCollection.doc(id).delete();
  }
}


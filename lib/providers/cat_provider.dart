import 'package:flutter/material.dart';
import '../models/cat_model.dart';
import '../services/cat_service.dart';

class CatProvider with ChangeNotifier {
  final CatService _catService = CatService();
  List<CatModel> _cats = [];
  bool _isLoading = false;

  List<CatModel> get cats => _cats;
  bool get isLoading => _isLoading;

  CatProvider() {
    _init();
  }

  void _init() {
    _isLoading = true;
    _cats = _catService.getAllCats();
    _isLoading = false;
    notifyListeners();

    _catService.streamCats().listen((updatedCats) {
      _cats = updatedCats;
      notifyListeners();
    });
  }
}

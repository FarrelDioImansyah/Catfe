import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _userModel;
  bool _isLoading = false;

  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _userModel != null;

  AuthProvider() {
    _checkCurrentSession();
  }

  void _checkCurrentSession() {
    _userModel = _authService.getCurrentUser();
    notifyListeners();
  }

  Future<void> register(String email, String password, String name, String username) async {
    _isLoading = true;
    notifyListeners();
    try {
      _userModel = await _authService.register(email, password, name, username);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      _userModel = await _authService.login(email, password);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();
    try {
      final user = await _authService.signInWithGoogle();
      if (user != null) {
        _userModel = user;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile({String? profileImageUrl, String? birthDate}) async {
    if (_userModel == null) return;
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.updateUserProfile(
        uid: _userModel!.uid,
        profileImageUrl: profileImageUrl,
        birthDate: birthDate,
      );
      _userModel = _userModel!.copyWith(
        profileImageUrl: profileImageUrl ?? _userModel!.profileImageUrl,
        birthDate: birthDate ?? _userModel!.birthDate,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _userModel = null;
    notifyListeners();
  }
}



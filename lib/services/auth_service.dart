import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';

class AuthService {
  final Box _userBox = Hive.box('users');
  final Box _settingsBox = Hive.box('settings');

  AuthService() {
    _seedAdmin();
  }

  // Create a default admin account for local testing
  void _seedAdmin() {
    const adminEmail = 'admin@catfe.com';
    if (!_userBox.containsKey(adminEmail)) {
      final adminUser = UserModel(
        uid: adminEmail,
        email: adminEmail,
        name: 'Cat Cafe Admin',
        role: UserRole.admin,
      );

      _userBox.put(adminEmail, {
        'userData': adminUser.toMap(),
        'password': 'admin123',
      });
    }
  }

  // Register locally
  Future<UserModel?> register(String email, String password, String name) async {
    if (_userBox.containsKey(email)) {
      throw 'User already exists with this email';
    }

    final newUser = UserModel(
      uid: email,
      email: email,
      name: name,
      role: UserRole.customer,
    );

    await _userBox.put(email, {
      'userData': newUser.toMap(),
      'password': password,
    });

    return newUser;
  }

  // Login locally
  Future<UserModel?> login(String email, String password) async {
    final data = _userBox.get(email);
    
    if (data == null || data['password'] != password) {
      throw 'Invalid email or password';
    }

    final user = UserModel.fromMap(Map<String, dynamic>.from(data['userData']));
    
    await _settingsBox.put('currentUserEmail', email);
    
    return user;
  }

  // Logout
  Future<void> logout() async {
    await _settingsBox.delete('currentUserEmail');
  }

  // Get current session
  UserModel? getCurrentUser() {
    final email = _settingsBox.get('currentUserEmail');
    if (email == null) return null;
    
    final data = _userBox.get(email);
    if (data == null) return null;
    
    return UserModel.fromMap(Map<String, dynamic>.from(data['userData']));
  }
}

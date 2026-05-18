import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

  // Mengambil profile data (termasuk role) dari Firestore
  Future<UserModel?> getUserProfile(String uid) async {
    try {
      final doc = await _userCollection.doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
    return null;
  }

  // Register dengan Email & Password ke Firebase Auth & Firestore
  Future<UserModel?> register(String email, String password, String name) async {
    try {
      // 1. Buat user di Firebase Auth
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? firebaseUser = credential.user;
      if (firebaseUser == null) return null;

      // Update nama di profile Firebase Auth
      await firebaseUser.updateDisplayName(name);

      // 2. Tentukan role (email admin@catfe.com atau berakhiran admin@catfe.com jadi admin)
      UserRole role = email.endsWith('admin@catfe.com') ? UserRole.admin : UserRole.customer;

      final newUser = UserModel(
        uid: firebaseUser.uid,
        email: email,
        name: name,
        role: role,
      );

      // 3. Simpan metadata user (seperti role) ke Firestore database
      await _userCollection.doc(firebaseUser.uid).set(newUser.toMap());

      return newUser;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Registration failed';
    }
  }

  // Login ke Firebase Auth
  Future<UserModel?> login(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? firebaseUser = credential.user;
      if (firebaseUser == null) return null;

      // Ambil profile lengkap (role admin/customer) dari Firestore
      UserModel? profile = await getUserProfile(firebaseUser.uid);
      
      // Jika profile tidak ada di database, buat profil default
      if (profile == null) {
        profile = UserModel(
          uid: firebaseUser.uid,
          email: email,
          name: firebaseUser.displayName ?? 'Customer',
          role: email.endsWith('admin@catfe.com') ? UserRole.admin : UserRole.customer,
        );
        await _userCollection.doc(firebaseUser.uid).set(profile.toMap());
      }

      return profile;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Login failed';
    }
  }

  // Logout dari Firebase Auth
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Get current session secara sinkronous (untuk auto-login saat startup)
  UserModel? getCurrentUser() {
    final User? firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;

    final bool isAdminEmail = firebaseUser.email != null && firebaseUser.email!.endsWith('admin@catfe.com');

    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      name: firebaseUser.displayName ?? 'Customer',
      role: isAdminEmail ? UserRole.admin : UserRole.customer,
    );
  }
}


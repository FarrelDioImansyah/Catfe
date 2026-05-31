import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
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
  Future<UserModel?> register(String email, String password, String name, String username) async {
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
        username: username,
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
          username: email.split('@').first,
          role: email.endsWith('admin@catfe.com') ? UserRole.admin : UserRole.customer,
        );
        await _userCollection.doc(firebaseUser.uid).set(profile.toMap());
      }

      return profile;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Login failed';
    }
  }

  // Login/Register with Google
  Future<UserModel?> signInWithGoogle() async {
    try {
      // 1. Trigger the full interactive Google authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate();
      if (googleUser == null) return null; // User cancelled the sign-in

      // 2. Obtain the auth tokens (in v7, authentication is a direct getter, not a Future)
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // 3. Create a Firebase credential using the idToken
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // 4. Sign in to Firebase with the credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;
      if (firebaseUser == null) return null;

      final String email = firebaseUser.email ?? '';

      // 5. Fetch profile from Firestore, or create if new
      UserModel? profile = await getUserProfile(firebaseUser.uid);
      if (profile == null) {
        final String generatedUsername = email.isNotEmpty
            ? email.split('@').first
            : 'user_${firebaseUser.uid.substring(0, 5)}';
        profile = UserModel(
          uid: firebaseUser.uid,
          email: email,
          name: firebaseUser.displayName ?? 'Customer',
          username: generatedUsername,
          role: email.endsWith('admin@catfe.com') ? UserRole.admin : UserRole.customer,
        );
        await _userCollection.doc(firebaseUser.uid).set(profile.toMap());
      }

      return profile;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Firebase auth failed';
    } catch (e) {
      throw 'An error occurred during Google Sign-In: $e';
    }
  }

  // Logout dari Firebase Auth & Google Sign-In
  Future<void> logout() async {
    await _auth.signOut();
    await GoogleSignIn.instance.signOut();
  }

  // Update user profile di Firestore
  Future<void> updateUserProfile({
    required String uid,
    String? profileImageUrl,
    String? birthDate,
  }) async {
    final Map<String, dynamic> updates = {};
    if (profileImageUrl != null) updates['profileImageUrl'] = profileImageUrl;
    if (birthDate != null) updates['birthDate'] = birthDate;

    if (updates.isNotEmpty) {
      await _userCollection.doc(uid).set(updates, SetOptions(merge: true));
    }
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
      username: firebaseUser.email != null ? firebaseUser.email!.split('@').first : 'customer',
      role: isAdminEmail ? UserRole.admin : UserRole.customer,
    );
  }
}



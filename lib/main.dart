import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Providers
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'providers/cat_provider.dart';
import 'providers/admin_provider.dart';

// Screens & Core
import 'features/auth/screens/auth_wrapper.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase secara global
  await Firebase.initializeApp();

  // Initialize Google Sign In (required by google_sign_in v7)
  await GoogleSignIn.instance.initialize();

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Open settings Hive box untuk data keranjang belanja lokal
  await Hive.openBox('settings');


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProxyProvider<AuthProvider, CartProvider>(
          create: (_) => CartProvider(),
          update: (_, auth, cart) => cart!..update(auth.userModel?.uid),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrderProvider>(
          create: (_) => OrderProvider(),
          update: (_, auth, order) => order!..update(auth.userModel?.uid),
        ),
        ChangeNotifierProvider(create: (_) => CatProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
      ],
      child: const CatCafeApp(),
    ),
  );
}

class CatCafeApp extends StatelessWidget {
  const CatCafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cat Café',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AuthWrapper(),
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}

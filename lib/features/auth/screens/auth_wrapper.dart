import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import 'login_screen.dart';
import '../../home/screens/main_navigation_screen.dart';
import '../../admin/screens/admin_navigation.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.isAuthenticated) {
      // Check if user is Admin
      if (authProvider.userModel?.isAdmin ?? false) {
        return const AdminNavigation();
      }
      return const MainNavigationScreen();
    } else {
      return const LoginScreen();
    }
  }
}

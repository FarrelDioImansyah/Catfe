import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().userModel;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.profile);
      },
      child: CircleAvatar(
        radius: 18,
        backgroundColor: AppColors.pastelPeach,
        backgroundImage: user?.profileImageUrl != null &&
                user!.profileImageUrl!.isNotEmpty
            ? NetworkImage(user.profileImageUrl!)
            : null,
        child: user?.profileImageUrl == null ||
                user!.profileImageUrl!.isEmpty
            ? Text(
                user?.name.isNotEmpty == true
                    ? user!.name[0].toUpperCase()
                    : 'U',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepBrown,
                ),
              )
            : null,
      ),
    );
  }
}

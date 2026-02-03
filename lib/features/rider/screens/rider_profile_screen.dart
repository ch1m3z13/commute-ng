import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/app_provider.dart';
import '../../../widgets/shared_widgets.dart';

class RiderProfileScreen extends StatelessWidget {
  final VoidCallback onLogout;

  const RiderProfileScreen({
    super.key,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final user = provider.user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.slate50,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            title: const Text('Profile'),
            backgroundColor: AppColors.white,
            foregroundColor: AppColors.slate900,
            elevation: 0,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // User info
                Row(
                  children: [
                    UserAvatar(
                      name: user.name,
                      size: 72,
                      verified: user.isVerified,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.slate900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rider • ${user.phone}',
                            style: const TextStyle(
                              color: AppColors.slate500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Menu items
                _MenuItem(
                  icon: Icons.person,
                  title: 'Personal Details',
                  onTap: () {},
                ),
                _MenuItem(
                  icon: Icons.shield,
                  title: 'Verification Status',
                  badge: 'Verified',
                  badgeColor: AppColors.emerald100,
                  badgeTextColor: AppColors.emerald700,
                  onTap: () {},
                ),
                _MenuItem(
                  icon: Icons.credit_card,
                  title: 'Saved Cards',
                  onTap: () {},
                ),
                _MenuItem(
                  icon: Icons.settings,
                  title: 'App Settings',
                  onTap: () {},
                ),
                const SizedBox(height: 24),

                // Logout button
                GestureDetector(
                  onTap: onLogout,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.red100),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.logout,
                          color: AppColors.red500,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Log Out',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.red500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? badge;
  final Color? badgeColor;
  final Color? badgeTextColor;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.badge,
    this.badgeColor,
    this.badgeTextColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.slate100),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: AppColors.slate400,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.slate700,
                ),
              ),
            ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: badgeColor ?? AppColors.slate100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badge!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: badgeTextColor ?? AppColors.slate700,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right,
              size: 16,
              color: AppColors.slate300,
            ),
          ],
        ),
      ),
    );
  }
}
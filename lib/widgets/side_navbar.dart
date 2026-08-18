import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SideNavBar extends StatelessWidget {
  const SideNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 256, // 64 * 4 for w-64
      height: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainer,
        border: Border(
          right: BorderSide(color: AppColors.outline),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.only(bottom: 32, left: 16),
            child: Row(
              children: [
                const Icon(
                  Icons.downloading,
                  color: AppColors.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Shrimp Drive',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      'ADMIN CONSOLE',
                      style: TextStyle(
                        color: AppColors.onSurfaceVariant.withOpacity(0.8),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Navigation Items
          Expanded(
            child: ListView(
              children: [
                _buildNavItem(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  isActive: true,
                ),
                const SizedBox(height: 8),
                _buildNavItem(
                  icon: Icons.key,
                  title: 'Invitation Codes',
                  isActive: false,
                ),
                const SizedBox(height: 8),
                _buildNavItem(
                  icon: Icons.group,
                  title: 'Users Management',
                  isActive: false,
                ),
                const SizedBox(height: 8),
                _buildNavItem(
                  icon: Icons.storage,
                  title: 'Telegram Storage',
                  isActive: false,
                ),
                const SizedBox(height: 8),
                _buildNavItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  isActive: false,
                ),
              ],
            ),
          ),
          
          // Footer
          const Divider(color: AppColors.outline),
          const SizedBox(height: 16),
          _buildNavItem(
            icon: Icons.logout,
            title: 'Logout',
            isActive: false,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String title,
    required bool isActive,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isActive ? AppColors.surfaceContainerHigh : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        border: isActive
            ? const Border(
                right: BorderSide(color: AppColors.primary, width: 2),
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(4),
          hoverColor: AppColors.surfaceContainerHighest,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/users_list_view.dart';
import '../widgets/user_detail_panel.dart';

class UsersManagementScreen extends StatelessWidget {
  const UsersManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Users Management',
                      style: TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'View and manage user access, storage quotas, and encryption keys.',
                      style: TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                // Search & Filters
                Row(
                  children: [
                    SizedBox(
                      width: 256,
                      height: 40,
                      child: TextField(
                        style: const TextStyle(color: AppColors.onSurface, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Search users by ID or email...',
                          hintStyle: TextStyle(color: AppColors.onSurfaceVariant.withOpacity(0.5), fontSize: 14),
                          prefixIcon: const Icon(Icons.search, color: AppColors.onSurfaceVariant, size: 20),
                          filled: true,
                          fillColor: AppColors.surfaceContainer,
                          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(color: AppColors.outline),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(color: AppColors.primary),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.filter_list, size: 18),
                      label: const Text('Filter'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.onSurface,
                        backgroundColor: AppColors.surfaceContainer,
                        side: const BorderSide(color: AppColors.outline),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        minimumSize: const Size(0, 40),
                        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Bento Layout: Master-Detail
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // MASTER VIEW (Spans 8 of 12 columns conceptually -> flex: 8)
                  const Expanded(
                    flex: 8,
                    child: UsersListView(),
                  ),
                  const SizedBox(width: 20),
                  // DETAIL VIEW (Spans 4 of 12 columns conceptually -> flex: 4)
                  const Expanded(
                    flex: 4,
                    child: SingleChildScrollView(
                      child: UserDetailPanel(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/invitation_codes_table.dart';

class InvitationCodesScreen extends StatelessWidget {
  const InvitationCodesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                      'Invitation Codes',
                      style: TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Manage and audit system access tokens.',
                      style: TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.filter_list, size: 16),
                      label: const Text('Filter'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.onSurface,
                        side: const BorderSide(color: AppColors.outline),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.download, size: 16),
                      label: const Text('Export'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.onSurface,
                        side: const BorderSide(color: AppColors.outline),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Table Section
            const InvitationCodesTable(),
            const SizedBox(height: 48), // Bottom padding
          ],
        ),
      ),
    );
  }
}

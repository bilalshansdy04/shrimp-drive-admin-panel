import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class UserDetailPanel extends StatelessWidget {
  const UserDetailPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Identity & Storage Card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.outline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppColors.outline),
                    ),
                    child: const Icon(Icons.person, color: AppColors.onSurfaceVariant, size: 24),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'alex.mercer',
                          style: TextStyle(
                            color: AppColors.onSurface,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'ID: USR-8829-X',
                          style: TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 12,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.5),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(color: AppColors.outline, height: 1),
              const SizedBox(height: 24),
              
              // Storage Allocation
              const Text(
                'STORAGE ALLOCATION',
                style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    '85.4',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 32,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w600,
                      height: 1.0,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 2.0, left: 2.0),
                    child: Text(
                      'GB',
                      style: TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'of 100 GB Limit',
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // Segmented Bar
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(color: AppColors.outline),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 45,
                      child: Container(color: AppColors.secondary),
                    ),
                    const SizedBox(width: 1),
                    Expanded(
                      flex: 30,
                      child: Container(color: AppColors.tertiary),
                    ),
                    const SizedBox(width: 1),
                    Expanded(
                      flex: 10,
                      child: Container(color: AppColors.primary),
                    ),
                    const SizedBox(width: 1),
                    Expanded(
                      flex: 15,
                      child: Container(), // Free space
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Legend
              Row(
                children: [
                  Expanded(child: _buildLegendItem('Photos (45GB)', AppColors.secondary)),
                  Expanded(child: _buildLegendItem('Videos (30GB)', AppColors.tertiary)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _buildLegendItem('Docs (10.4GB)', AppColors.primary)),
                  Expanded(
                    child: _buildLegendItem(
                      'Free (14.6GB)',
                      AppColors.surfaceContainerHighest,
                      hasBorder: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Administrative Actions Card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.outline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ADMINISTRATIVE ACTIONS',
                style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              
              _buildActionRow(
                title: 'Edit Quota Limit',
                subtitle: 'Currently set to 100 GB',
                icon: Icons.edit,
                hoverColor: AppColors.primary,
              ),
              const SizedBox(height: 12),
              _buildActionRow(
                title: 'Regenerate Keys',
                subtitle: 'Force AES-256 key rotation',
                icon: Icons.vpn_key,
                hoverColor: AppColors.secondary,
              ),
              
              const SizedBox(height: 16),
              const Divider(color: AppColors.outline, height: 1),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.block, size: 18),
                      label: const Text('Suspend'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: BorderSide(color: AppColors.error.withOpacity(0.5)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.delete_forever, size: 18),
                      label: const Text('Delete', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.error.withOpacity(0.1),
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, {bool hasBorder = false}) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: hasBorder ? Border.all(color: AppColors.outline) : null,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildActionRow({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color hoverColor,
  }) {
    // Note: Simple visual implementation, hover states require Stateful/InkWell
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface, // Maps to surface-dim
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          Icon(icon, color: AppColors.onSurfaceVariant, size: 20),
        ],
      ),
    );
  }
}

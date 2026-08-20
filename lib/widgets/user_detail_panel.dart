import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../providers/users_provider.dart';
import '../utils/formatters.dart';

class UserDetailPanel extends ConsumerWidget {
  const UserDetailPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(selectedUserProvider);

    if (user == null) {
      return Container(
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        child: const Text('Select a user to view details', style: TextStyle(color: AppColors.onSurfaceVariant)),
      );
    }

    final quotaUsedStr = Formatters.formatBytes(user.storageUsed);
    final quotaMaxStr = Formatters.formatBytes(user.storageLimit);
    final baseStorageStr = Formatters.formatBytes(user.baseStorage);
    final inviteBonusStr = Formatters.formatBytes(user.invitationBonusStorage);
    final customBonusStr = Formatters.formatBytes(user.customStorageBonus);
    final quotaProgress = user.storageLimit > 0 ? (user.storageUsed / user.storageLimit).clamp(0.0, 1.0) : 0.0;

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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.username,
                          style: const TextStyle(
                            color: AppColors.onSurface,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'ID: ${user.id}',
                          style: const TextStyle(
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
                      color: user.isActive ? AppColors.primary : AppColors.error,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (user.isActive ? AppColors.primary : AppColors.error).withValues(alpha: 0.5),
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
                  Text(
                    quotaUsedStr.split(' ')[0],
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 32,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w600,
                      height: 1.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2.0, left: 2.0),
                    child: Text(
                      quotaUsedStr.split(' ').length > 1 ? quotaUsedStr.split(' ')[1] : '',
                      style: const TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'of $quotaMaxStr Limit',
                    style: const TextStyle(
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
                    if (quotaProgress > 0)
                      Expanded(
                        flex: (quotaProgress * 100).toInt() == 0 ? 1 : (quotaProgress * 100).toInt(),
                        child: Container(color: quotaProgress > 0.9 ? AppColors.error : AppColors.primary),
                      ),
                    if (quotaProgress < 1)
                      Expanded(
                        flex: (100 - (quotaProgress * 100)).toInt() == 0 ? 1 : (100 - (quotaProgress * 100)).toInt(),
                        child: Container(), // Free space
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Legend
              Row(
                children: [
                  Expanded(child: _buildLegendItem('Base ($baseStorageStr)', AppColors.secondary)),
                  Expanded(child: _buildLegendItem('Invite Bonus ($inviteBonusStr)', AppColors.tertiary)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _buildLegendItem('Custom Bonus ($customBonusStr)', AppColors.primary)),
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
                title: 'Edit Custom Storage Bonus',
                subtitle: 'Currently set to $customBonusStr',
                icon: Icons.edit,
                hoverColor: AppColors.primary,
                onTap: () {
                  _showEditStorageDialog(context, ref, user.id, user.customStorageBonus);
                }
              ),
              const SizedBox(height: 12),
              _buildActionRow(
                title: 'Reset Password',
                subtitle: 'Force password reset',
                icon: Icons.lock_reset,
                hoverColor: AppColors.secondary,
                onTap: () {
                  _showResetPasswordDialog(context, ref, user.id);
                }
              ),
              
              const SizedBox(height: 16),
              const Divider(color: AppColors.outline, height: 1),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ref.read(usersProvider.notifier).toggleUserStatus(user.id, user.isActive);
                      },
                      icon: Icon(user.isActive ? Icons.block : Icons.check_circle_outline, size: 18),
                      label: Text(user.isActive ? 'Deactivate (Soft Delete)' : 'Activate User'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: user.isActive ? AppColors.error : AppColors.primary,
                        side: BorderSide(color: (user.isActive ? AppColors.error : AppColors.primary).withValues(alpha: 0.5)),
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

  void _showEditStorageDialog(BuildContext context, WidgetRef ref, String userId, int currentBonusBytes) {
    final controller = TextEditingController(text: (currentBonusBytes / 1073741824).toStringAsFixed(2)); // GB
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceContainerHigh,
          title: const Text('Edit Custom Storage Bonus (GB)', style: TextStyle(color: AppColors.onSurface)),
          content: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(color: AppColors.onSurface),
            decoration: const InputDecoration(
              filled: true,
              fillColor: AppColors.surfaceContainer,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final gb = double.tryParse(controller.text) ?? 0.0;
                final bytes = (gb * 1073741824).toInt();
                ref.read(usersProvider.notifier).updateCustomStorage(userId, bytes);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            )
          ],
        );
      }
    );
  }

  void _showResetPasswordDialog(BuildContext context, WidgetRef ref, String userId) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceContainerHigh,
          title: const Text('Reset Password', style: TextStyle(color: AppColors.onSurface)),
          content: TextField(
            controller: controller,
            obscureText: true,
            style: const TextStyle(color: AppColors.onSurface),
            decoration: const InputDecoration(
              hintText: 'New Password',
              filled: true,
              fillColor: AppColors.surfaceContainer,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                ref.read(usersProvider.notifier).resetPassword(userId, controller.text);
                Navigator.pop(context);
              },
              child: const Text('Reset'),
            )
          ],
        );
      }
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
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}

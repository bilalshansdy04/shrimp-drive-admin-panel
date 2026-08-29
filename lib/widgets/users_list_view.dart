import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../providers/users_provider.dart';
import '../utils/formatters.dart';

class UsersListView extends ConsumerStatefulWidget {
  const UsersListView({super.key});

  @override
  ConsumerState<UsersListView> createState() => _UsersListViewState();
}

class _UsersListViewState extends ConsumerState<UsersListView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(usersProvider.notifier).build());
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(usersProvider);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              border: Border(bottom: BorderSide(color: AppColors.outline)),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'USER / ID',
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'STATUS',
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'INVITE CODE',
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'QUOTA USED',
                        style: TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        'QUOTA TOTAL',
                        style: TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Body List
          Expanded(
            child: usersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                  child: Text('Error: $err',
                      style: const TextStyle(color: Colors.red))),
              data: (users) {
                if (users.isEmpty) {
                  return const Center(
                      child: Text('No users found',
                          style: TextStyle(color: AppColors.onSurfaceVariant)));
                }
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final quotaUsed = Formatters.formatBytes(user.storageUsed);
                    final quotaMax = Formatters.formatBytes(user.storageLimit);
                    final quotaProgress = user.storageLimit > 0
                        ? (user.storageUsed / user.storageLimit).clamp(0.0, 1.0)
                        : 0.0;

                    return _buildRow(
                        isSelected:
                            false, // You can implement selection state if needed
                        email: user.email ?? user.username,
                        id: user.id,
                        invitationCodeUsed: user.invitationCodeUsed,
                        status: user.isActive ? 'Active' : 'Deactivated',
                        statusColor:
                            user.isActive ? AppColors.primary : AppColors.error,
                        statusBgColor: user.isActive
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : AppColors.error.withValues(alpha: 0.1),
                        statusBorderColor: user.isActive
                            ? AppColors.primary.withValues(alpha: 0.2)
                            : AppColors.error.withValues(alpha: 0.2),
                        quotaUsed: quotaUsed,
                        quotaMax: quotaMax,
                        quotaProgress: quotaProgress,
                        quotaColor: quotaProgress > 0.9
                            ? AppColors.error
                            : AppColors.primary,
                        isStrikethrough: !user.isActive,
                        onTap: () {
                          ref.read(selectedUserIdProvider.notifier).state =
                              user.id;
                        });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow({
    required bool isSelected,
    required String email,
    required String id,
    String? invitationCodeUsed,
    required String status,
    required Color statusColor,
    required Color statusBgColor,
    required Color statusBorderColor,
    required String quotaUsed,
    required String quotaMax,
    required double quotaProgress,
    required Color quotaColor,
    bool isGradient = false,
    bool isStrikethrough = false,
    required VoidCallback onTap,
  }) {
    return Material(
      color: isSelected ? AppColors.surfaceContainerHigh : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        hoverColor: AppColors.surfaceContainerHigh,
        child: Container(
          decoration: BoxDecoration(
            border: const Border(bottom: BorderSide(color: AppColors.outline)),
            color: isStrikethrough ? Colors.transparent : null,
          ),
          foregroundDecoration: isSelected
              ? const BoxDecoration(
                  border: Border(
                      left: BorderSide(color: AppColors.primary, width: 4)),
                )
              : null,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Opacity(
            opacity: isStrikethrough ? 0.6 : 1.0,
            child: Row(
              children: [
                // User / ID
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        email,
                        style: TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          decoration: isStrikethrough
                              ? TextDecoration.lineThrough
                              : null,
                          decorationColor: AppColors.error,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        id,
                        style: const TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 10,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
                // Status
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusBgColor,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: statusBorderColor),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            status,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Invitation Code
                Expanded(
                  flex: 2,
                  child: Text(
                    invitationCodeUsed ?? '-',
                    style: const TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 14,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                // Quota
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(quotaUsed,
                              style: const TextStyle(
                                  color: AppColors.onSurfaceVariant,
                                  fontSize: 10)),
                          Text(quotaMax,
                              style: const TextStyle(
                                  color: AppColors.onSurfaceVariant,
                                  fontSize: 10)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                          border: isStrikethrough
                              ? Border.all(
                                  color: AppColors.error.withValues(alpha: 0.3))
                              : null,
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: quotaProgress,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: isGradient
                                  ? const LinearGradient(colors: [
                                      AppColors.secondary,
                                      AppColors.tertiary
                                    ])
                                  : null,
                              color: isGradient ? null : quotaColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ],
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

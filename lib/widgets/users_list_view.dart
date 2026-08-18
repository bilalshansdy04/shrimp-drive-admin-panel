import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'pagination_footer.dart';

class UsersListView extends StatelessWidget {
  const UsersListView({super.key});

  @override
  Widget build(BuildContext context) {
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
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'ACCESS TYPE',
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'ENCRYPTION',
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    'QUOTA USED',
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Body List
          Expanded(
            child: ListView(
              children: [
                _buildRow(
                  isSelected: true,
                  email: 'alex.mercer@corp.net',
                  id: 'USR-8829-X',
                  accessType: 'Premium Bot',
                  accessTypeColor: AppColors.secondary,
                  accessTypeBgColor: AppColors.secondary.withOpacity(0.1),
                  accessTypeBorderColor: AppColors.secondary.withOpacity(0.2),
                  encryptionIcon: Icons.lock,
                  encryptionText: 'AES-256',
                  quotaUsed: '85.4 GB',
                  quotaMax: '100 GB',
                  quotaProgress: 0.854,
                  quotaColor: AppColors.primary,
                ),
                _buildRow(
                  isSelected: false,
                  email: 'sarah.j@studio.io',
                  id: 'USR-4412-M',
                  accessType: 'Standard Web',
                  accessTypeColor: AppColors.onSurfaceVariant,
                  accessTypeBgColor: AppColors.surfaceVariant,
                  accessTypeBorderColor: AppColors.outline,
                  encryptionIcon: Icons.lock_open,
                  encryptionText: 'None',
                  quotaUsed: '12.1 GB',
                  quotaMax: '50 GB',
                  quotaProgress: 0.242,
                  quotaColor: AppColors.secondary, // Gradient in HTML, solid here for simplicity or we can build gradient
                  isGradient: true,
                ),
                _buildRow(
                  isSelected: false,
                  email: 'm.vasquez@temp.org',
                  id: 'USR-9901-Z',
                  accessType: 'Suspended',
                  accessTypeColor: AppColors.error,
                  accessTypeBgColor: AppColors.error.withOpacity(0.1),
                  accessTypeBorderColor: AppColors.error.withOpacity(0.2),
                  encryptionIcon: Icons.lock,
                  encryptionText: 'AES-256',
                  quotaUsed: '50.0 GB',
                  quotaMax: '50 GB',
                  quotaProgress: 1.0,
                  quotaColor: AppColors.error,
                  isStrikethrough: true,
                ),
              ],
            ),
          ),
          // Footer
          const PaginationFooter(
            currentPage: 1,
            totalPages: 100,
            startItem: 1,
            endItem: 3,
            totalItems: 1248,
          ),
        ],
      ),
    );
  }

  Widget _buildRow({
    required bool isSelected,
    required String email,
    required String id,
    required String accessType,
    required Color accessTypeColor,
    required Color accessTypeBgColor,
    required Color accessTypeBorderColor,
    required IconData encryptionIcon,
    required String encryptionText,
    required String quotaUsed,
    required String quotaMax,
    required double quotaProgress,
    required Color quotaColor,
    bool isGradient = false,
    bool isStrikethrough = false,
  }) {
    return Material(
      color: isSelected ? AppColors.surfaceContainerHigh : Colors.transparent,
      child: InkWell(
        onTap: () {},
        hoverColor: AppColors.surfaceContainerHigh,
        child: Container(
          decoration: BoxDecoration(
            border: const Border(bottom: BorderSide(color: AppColors.outline)),
            color: isStrikethrough ? Colors.transparent : null,
          ),
          foregroundDecoration: isSelected
              ? const BoxDecoration(
                  border: Border(left: BorderSide(color: AppColors.primary, width: 4)),
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
                          decoration: isStrikethrough ? TextDecoration.lineThrough : null,
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
                // Access Type
                Expanded(
                  flex: 3,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: accessTypeBgColor,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: accessTypeBorderColor),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: accessTypeColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            accessType,
                            style: TextStyle(
                              color: accessTypeColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Encryption
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Icon(
                        encryptionIcon,
                        size: 16,
                        color: encryptionText == 'None' ? AppColors.onSurfaceVariant : AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        encryptionText,
                        style: TextStyle(
                          color: encryptionText == 'None' ? AppColors.onSurfaceVariant : AppColors.onSurface,
                          fontSize: 12,
                        ),
                      ),
                    ],
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
                          Text(quotaUsed, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 10)),
                          Text(quotaMax, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 10)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                          border: isStrikethrough ? Border.all(color: AppColors.error.withOpacity(0.3)) : null,
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: quotaProgress,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: isGradient
                                  ? const LinearGradient(colors: [AppColors.secondary, AppColors.tertiary])
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

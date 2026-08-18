import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'pagination_footer.dart';

class InvitationCodesTable extends StatelessWidget {
  const InvitationCodesTable({super.key});

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
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: constraints.maxWidth > 1000 ? constraints.maxWidth : 1000,
                  ),
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(AppColors.surfaceContainerHigh),
                    dataRowMinHeight: 72,
                    dataRowMaxHeight: 72,
                    headingTextStyle: const TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.5,
                    ),
                    dividerThickness: 1,
                    columns: const [
                      DataColumn(label: Text('CODE HASH')),
                      DataColumn(label: Text('SETUP TYPE')),
                      DataColumn(label: Text('ENCRYPTION')),
                      DataColumn(label: Text('QUOTA LIMIT')),
                      DataColumn(label: Text('STATUS')),
                      DataColumn(label: Text('USED BY / CREATED')),
                      DataColumn(label: Text('ACTIONS'), numeric: true),
                    ],
                    rows: [
                      _buildRow(
                        code: 'SD-X9F2-K1L8',
                        isStrikethrough: false,
                        setupType: 'Zero Setup',
                        encryptionIcon: Icons.lock,
                        encryptionText: 'AES-256',
                        quotaUsed: '12 GB',
                        quotaMax: '50 GB',
                        quotaProgress: 0.24,
                        quotaColor: AppColors.primary,
                        statusText: 'Active',
                        statusColor: AppColors.secondary,
                        statusBgColor: AppColors.secondary.withOpacity(0.1),
                        user: 'user_492@corp.com',
                        time: '2h ago',
                        actions: [Icons.block, Icons.more_vert],
                      ),
                      _buildRow(
                        code: 'SD-M4V7-P0Q3',
                        isStrikethrough: false,
                        setupType: 'Self Setup',
                        encryptionIcon: Icons.lock_open,
                        encryptionText: 'None',
                        quotaUsed: '48 GB',
                        quotaMax: '50 GB',
                        quotaProgress: 0.96,
                        quotaColor: AppColors.error,
                        statusText: 'Unused',
                        statusColor: AppColors.primary,
                        statusBgColor: AppColors.primary.withOpacity(0.1),
                        user: '-',
                        isUserItalic: true,
                        time: '1d ago',
                        actions: [Icons.delete, Icons.more_vert],
                      ),
                      _buildRow(
                        code: 'SD-A1B2-C3D4',
                        isStrikethrough: true,
                        setupType: 'Zero Setup',
                        encryptionIcon: Icons.lock,
                        encryptionText: 'AES-256',
                        isRevoked: true,
                        quotaColor: AppColors.surfaceContainerLowest, // Not used
                        statusText: 'Revoked',
                        statusColor: AppColors.error,
                        statusBgColor: AppColors.error.withOpacity(0.1),
                        user: 'admin_test@corp.com',
                        time: '5d ago',
                        actions: [Icons.more_vert],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const PaginationFooter(
            currentPage: 1,
            totalPages: 3,
            startItem: 1,
            endItem: 3,
            totalItems: 156,
          ),
        ],
      ),
    );
  }

  DataRow _buildRow({
    required String code,
    required bool isStrikethrough,
    required String setupType,
    required IconData encryptionIcon,
    required String encryptionText,
    String? quotaUsed,
    String? quotaMax,
    double? quotaProgress,
    required Color quotaColor,
    bool isRevoked = false,
    required String statusText,
    required Color statusColor,
    required Color statusBgColor,
    required String user,
    bool isUserItalic = false,
    required String time,
    required List<IconData> actions,
  }) {
    return DataRow(
      cells: [
        // CODE HASH
        DataCell(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              code,
              style: TextStyle(
                color: isStrikethrough ? AppColors.onSurfaceVariant : AppColors.onSurface,
                fontSize: 14,
                fontFamily: 'monospace',
                fontWeight: FontWeight.w500,
                decoration: isStrikethrough ? TextDecoration.lineThrough : null,
              ),
            ),
            if (!isStrikethrough) ...[
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.content_copy, size: 16),
                color: AppColors.onSurfaceVariant,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ]
          ],
        )),
        // SETUP TYPE
        DataCell(Text(
          setupType,
          style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14),
        )),
        // ENCRYPTION
        DataCell(Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AppColors.outline),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(encryptionIcon, size: 14, color: AppColors.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(
                encryptionText,
                style: const TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        )),
        // QUOTA LIMIT
        DataCell(isRevoked
            ? const Text('Revoked', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(quotaUsed ?? '', style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
                      Text(quotaMax ?? '', style: const TextStyle(color: AppColors.onSurface, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 8,
                    width: 140, // Fixed width for progress bar
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: quotaProgress ?? 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: quotaColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        // STATUS
        DataCell(Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusBgColor,
            borderRadius: BorderRadius.circular(4),
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
              const SizedBox(width: 6),
              Text(
                statusText,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  shadows: statusText == 'Active'
                      ? [
                          BoxShadow(
                            color: statusColor.withOpacity(0.5),
                            blurRadius: 4,
                          )
                        ]
                      : null,
                ),
              ),
            ],
          ),
        )),
        // USED BY / CREATED
        DataCell(Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user,
              style: TextStyle(
                color: isStrikethrough ? AppColors.onSurfaceVariant : (isUserItalic ? AppColors.onSurfaceVariant : AppColors.onSurface),
                fontSize: 14,
                fontStyle: isUserItalic ? FontStyle.italic : null,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              time,
              style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12),
            ),
          ],
        )),
        // ACTIONS
        DataCell(Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: actions.map((icon) {
            return Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(icon, size: 20),
                color: AppColors.onSurfaceVariant,
                hoverColor: icon == Icons.delete || icon == Icons.block ? AppColors.error.withOpacity(0.1) : AppColors.onSurface.withOpacity(0.1),
                onPressed: () {},
              ),
            );
          }).toList(),
        )),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../providers/invitation_codes_provider.dart';
import '../models/invitation_code.dart';
import 'invitation_code_form_dialog.dart';

class InvitationCodesTable extends ConsumerWidget {
  const InvitationCodesTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final codesAsyncValue = ref.watch(invitationCodesProvider);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: codesAsyncValue.when(
        data: (codes) => _buildTable(context, ref, codes),
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(48.0),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (e, st) => Center(
          child: Padding(
            padding: const EdgeInsets.all(48.0),
            child: Text('Error loading codes: $e', style: const TextStyle(color: AppColors.error)),
          ),
        ),
      ),
    );
  }

  Widget _buildTable(BuildContext context, WidgetRef ref, List<InvitationCode> codes) {
    return Column(
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
                    DataColumn(label: Text('CODE NAME')),
                    DataColumn(label: Text('SETUP TYPE')),
                    DataColumn(label: Text('ENCRYPTION')),
                    DataColumn(label: Text('ENCRYPTION KEY')),
                    DataColumn(label: Text('QUOTA LIMIT')),
                    DataColumn(label: Text('STATUS')),
                    DataColumn(label: Text('USED / MAX')),
                    DataColumn(label: Text('ACTIONS'), numeric: true),
                  ],
                  rows: codes.map((code) => _buildRow(context, ref, code)).toList(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  DataRow _buildRow(BuildContext context, WidgetRef ref, InvitationCode code) {
    final isStrikethrough = code.isRevoked;
    
    // Setup Type
    String setupType = code.type == 'friend_zero_setup' ? 'Zero Setup' : 'Self Setup';
    
    // Encryption
    IconData encryptionIcon = Icons.lock_outline;
    String encryptionText = 'Flexible';
    if (code.encryptionMode == 'locked_on') {
      encryptionIcon = Icons.lock;
      encryptionText = 'AES-256';
    } else if (code.encryptionMode == 'locked_off') {
      encryptionIcon = Icons.lock_open;
      encryptionText = 'None';
    }

    // Quota Limit
    String quotaMax = code.bonusAmount != null && code.bonusAmount! > 0
        ? '${(code.bonusAmount! / (1024 * 1024 * 1024)).toStringAsFixed(0)} GB'
        : 'Limitless';

    // Status
    String statusText = 'Unused';
    Color statusColor = AppColors.primary;
    Color statusBgColor = AppColors.primary.withValues(alpha: 0.1);

    if (code.isRevoked) {
      statusText = 'Revoked';
      statusColor = AppColors.error;
      statusBgColor = AppColors.error.withValues(alpha: 0.1);
    } else if (code.usedCount > 0) {
      statusText = 'Active';
      statusColor = AppColors.secondary;
      statusBgColor = AppColors.secondary.withValues(alpha: 0.1);
    }

    return DataRow(
      cells: [
        // CODE NAME
        DataCell(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              code.code,
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
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: code.code));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invitation Code copied!')));
                },
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
        // ENCRYPTION KEY
        DataCell(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              code.encryptionKey != null ? '${code.encryptionKey!.substring(0, 6)}...${code.encryptionKey!.substring(code.encryptionKey!.length - 6)}' : 'N/A',
              style: const TextStyle(
                color: AppColors.onSurfaceVariant,
                fontSize: 14,
                fontFamily: 'monospace',
              ),
            ),
            if (code.encryptionKey != null) ...[
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(Icons.content_copy, size: 14),
                color: AppColors.onSurfaceVariant,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: code.encryptionKey!));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Encryption key copied!')));
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ]
          ],
        )),
        // QUOTA LIMIT
        DataCell(Text(
          quotaMax, 
          style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14)
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
                            color: statusColor.withValues(alpha: 0.5),
                            blurRadius: 4,
                          )
                        ]
                      : null,
                ),
              ),
            ],
          ),
        )),
        // USED / MAX
        DataCell(Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${code.usedCount} / ${code.maxUses}',
              style: TextStyle(
                color: isStrikethrough ? AppColors.onSurfaceVariant : AppColors.onSurface,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'Uses',
              style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12),
            ),
          ],
        )),
        // ACTIONS
        DataCell(Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!code.isRevoked)
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                color: AppColors.onSurfaceVariant,
                hoverColor: AppColors.onSurface.withValues(alpha: 0.1),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => InvitationCodeFormDialog(existingCode: code),
                  );
                },
              ),
            if (!code.isRevoked)
              IconButton(
                icon: const Icon(Icons.block, size: 20),
                color: AppColors.onSurfaceVariant,
                hoverColor: AppColors.error.withValues(alpha: 0.1),
                onPressed: () {
                  ref.read(invitationCodesProvider.notifier).revokeCode(code.code);
                },
              ),
            if (code.usedCount == 0)
              IconButton(
                icon: const Icon(Icons.delete, size: 20),
                color: AppColors.onSurfaceVariant,
                hoverColor: AppColors.error.withValues(alpha: 0.1),
                onPressed: () {
                  ref.read(invitationCodesProvider.notifier).deleteCode(code.code);
                },
              ),
          ],
        )),
      ],
    );
  }
}

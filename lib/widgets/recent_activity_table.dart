import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class RecentActivityTable extends StatelessWidget {
  const RecentActivityTable({super.key});

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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              border: Border(bottom: BorderSide(color: AppColors.outline)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Activity',
                  style: TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.5,
                    ),
                  ),
                  child: const Text('VIEW ALL'),
                ),
              ],
            ),
          ),
          // Table Data
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: constraints.maxWidth > 800 ? constraints.maxWidth : 800,
                  ),
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(AppColors.surfaceContainerHigh),
                    dataRowMinHeight: 56,
                    dataRowMaxHeight: 56,
                    headingTextStyle: const TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.5,
                    ),
                    dataTextStyle: const TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 14,
                    ),
                    dividerThickness: 1,
                    columns: const [
                      DataColumn(label: Text('TIMESTAMP')),
                      DataColumn(label: Text('EVENT TYPE')),
                      DataColumn(label: Text('USER/ENTITY')),
                      DataColumn(label: Text('DETAILS')),
                      DataColumn(label: Text('STATUS'), numeric: true),
                    ],
                rows: [
                  _buildRow(
                    timestamp: '2023-10-27 14:32:01',
                    eventIcon: Icons.person_add,
                    eventColor: AppColors.secondary,
                    eventText: 'New Registration',
                    user: 'user_789x',
                    details: 'Used invite code ALPHA-99',
                    status: 'Success',
                    statusColor: AppColors.secondary,
                  ),
                  _buildRow(
                    timestamp: '2023-10-27 14:15:45',
                    eventIcon: Icons.cloud_upload,
                    eventColor: AppColors.tertiary,
                    eventText: 'Large File Upload',
                    user: 'archivist_01',
                    details: 'Dataset_v4.tar.gz (45GB)',
                    status: 'Completed',
                    statusColor: AppColors.secondary,
                  ),
                  _buildRow(
                    timestamp: '2023-10-27 13:50:12',
                    eventIcon: Icons.warning,
                    eventColor: AppColors.error,
                    eventText: 'Quota Warning',
                    user: 'data_node_4',
                    details: 'Approaching 95% storage capacity',
                    status: 'Alert',
                    statusColor: AppColors.error,
                  ),
                  _buildRow(
                    timestamp: '2023-10-27 12:05:00',
                    eventIcon: Icons.vpn_key,
                    eventColor: AppColors.primary,
                    eventText: 'Invite Generated',
                    user: 'admin_root',
                    details: 'Generated 50 new standard codes',
                    status: 'Success',
                    statusColor: AppColors.secondary,
                  ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  DataRow _buildRow({
    required String timestamp,
    required IconData eventIcon,
    required Color eventColor,
    required String eventText,
    required String user,
    required String details,
    required String status,
    required Color statusColor,
  }) {
    return DataRow(
      cells: [
        DataCell(Text(timestamp, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12))),
        DataCell(Row(
          children: [
            Icon(eventIcon, color: eventColor, size: 16),
            const SizedBox(width: 8),
            Text(eventText),
          ],
        )),
        DataCell(Text(user, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
        DataCell(Text(details, style: const TextStyle(color: AppColors.onSurfaceVariant))),
        DataCell(Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: statusColor.withOpacity(0.2)),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        )),
      ],
    );
  }
}

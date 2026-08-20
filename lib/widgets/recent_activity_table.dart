import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:intl/intl.dart';

class RecentActivityTable extends StatelessWidget {
  final Map<String, dynamic>? recentActivity;
  
  const RecentActivityTable({super.key, this.recentActivity});

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
                rows: _buildDynamicRows(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<DataRow> _buildDynamicRows() {
    if (recentActivity == null) return [];
    
    List<Map<String, dynamic>> allEvents = [];
    
    if (recentActivity!['users'] != null) {
      for (var u in recentActivity!['users']) {
        allEvents.add({
          'timestamp': DateTime.parse(u['createdAt']),
          'icon': Icons.person_add,
          'color': AppColors.secondary,
          'eventText': 'New Registration',
          'user': u['username'] ?? u['id'],
          'details': 'User signed up',
          'status': 'Success',
          'statusColor': AppColors.secondary,
        });
      }
    }
    
    if (recentActivity!['files'] != null) {
      for (var f in recentActivity!['files']) {
        allEvents.add({
          'timestamp': DateTime.parse(f['createdAt']),
          'icon': Icons.cloud_upload,
          'color': AppColors.tertiary,
          'eventText': 'File Upload',
          'user': 'system', // or fetch user from file info if available
          'details': f['fileName'],
          'status': 'Completed',
          'statusColor': AppColors.secondary,
        });
      }
    }
    
    allEvents.sort((a, b) => (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime));
    
    return allEvents.map((e) {
      return _buildRow(
        timestamp: DateFormat('yyyy-MM-dd HH:mm:ss').format(e['timestamp']),
        eventIcon: e['icon'],
        eventColor: e['color'],
        eventText: e['eventText'],
        user: e['user'],
        details: e['details'],
        status: e['status'],
        statusColor: e['statusColor'],
      );
    }).toList();
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
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: statusColor.withValues(alpha: 0.2)),
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

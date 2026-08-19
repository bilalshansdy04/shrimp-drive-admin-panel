import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../widgets/metric_card.dart';
import '../widgets/recent_activity_table.dart';
import '../providers/dashboard_provider.dart';
import '../utils/formatters.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsyncValue = ref.watch(dashboardProvider);

    return Stack(
      children: [
        // Main Content
        SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1280),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Page Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'System Overview',
                          style: TextStyle(
                            color: AppColors.onSurface,
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Live metrics and recent activity across the Shrimp Drive network.',
                          style: TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => ref.invalidate(dashboardProvider),
                      icon: const Icon(Icons.refresh),
                      tooltip: 'Refresh Dashboard',
                      color: AppColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Metrics Row
                dashboardAsyncValue.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.all(48.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (error, stack) => Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Error: $error', style: const TextStyle(color: AppColors.error)),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => ref.invalidate(dashboardProvider),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Coba Lagi (Retry)'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.surface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  data: (data) {
                    final rawStorageUsed = data['totalStorageUsed'] ?? 0;
                    final rawStorageLimit = data['totalStorageLimit'] ?? 1;
                    
                    final storageUsed = rawStorageUsed is num ? rawStorageUsed : num.tryParse(rawStorageUsed.toString()) ?? 0;
                    final storageLimit = rawStorageLimit is num ? rawStorageLimit : num.tryParse(rawStorageLimit.toString()) ?? 1;
                    
                    final storageProgress = storageLimit > 0 ? (storageUsed / storageLimit).clamp(0.0, 1.0) : 0.0;
                    
                    final formattedUsed = Formatters.formatBytes(storageUsed);
                    final formattedLimit = Formatters.formatBytes(storageLimit);
                    final usedParts = formattedUsed.split(' ');

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            double cardWidth = (constraints.maxWidth - 40) / 3;
                            if (cardWidth < 250) {
                              cardWidth = constraints.maxWidth;
                            }
                            
                            bool wrap = cardWidth == constraints.maxWidth;
                            
                            if (wrap) {
                              return Column(
                                children: [
                                  MetricCard(
                                    title: 'Total Active Users',
                                    value: '${data['totalActiveUsers'] ?? 0}',
                                    icon: Icons.group,
                                    iconColor: AppColors.primary,
                                  ),
                                  const SizedBox(height: 20),
                                  MetricCard(
                                    title: 'Total Storage Used',
                                    value: usedParts[0],
                                    suffix: usedParts.length > 1 ? usedParts[1] : '',
                                    icon: Icons.storage,
                                    iconColor: AppColors.tertiary,
                                    subtitle: '$formattedUsed / $formattedLimit',
                                    progressValue: storageProgress,
                                  ),
                                  const SizedBox(height: 20),
                                  MetricCard(
                                    title: 'Active Invitations',
                                    value: '${data['activeInvitationCodes'] ?? 0}',
                                    icon: Icons.vpn_key,
                                    iconColor: AppColors.secondary,
                                  ),
                                ],
                              );
                            }
                            
                            return Row(
                              children: [
                                Expanded(
                                  child: MetricCard(
                                    title: 'Total Active Users',
                                    value: '${data['totalActiveUsers'] ?? 0}',
                                    icon: Icons.group,
                                    iconColor: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: MetricCard(
                                    title: 'Total Storage Used',
                                    value: usedParts[0],
                                    suffix: usedParts.length > 1 ? usedParts[1] : '',
                                    icon: Icons.storage,
                                    iconColor: AppColors.tertiary,
                                    subtitle: '$formattedUsed / $formattedLimit',
                                    progressValue: storageProgress,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: MetricCard(
                                    title: 'Active Invitations',
                                    value: '${data['activeInvitationCodes'] ?? 0}',
                                    icon: Icons.vpn_key,
                                    iconColor: AppColors.secondary,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        RecentActivityTable(recentActivity: data['recentActivity']),
                      ],
                    );
                  },
                ),
                
                const SizedBox(height: 48), // Bottom padding
              ],
            ),
          ),
        ),
      ],
    );
  }
}

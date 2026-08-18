import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/side_navbar.dart';
import '../widgets/top_navbar.dart';
import '../widgets/metric_card.dart';
import '../widgets/recent_activity_table.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SideNavBar(),
          Expanded(
            child: Column(
              children: [
                const TopNavBar(),
                Expanded(
                  child: Stack(
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
                              const Text(
                                'System Overview',
                                style: TextStyle(
                                  color: AppColors.onSurface,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Live metrics and recent activity across the Shrimp Drive network.',
                                style: TextStyle(
                                  color: AppColors.onSurfaceVariant,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 24),
                              
                              // Metrics Row
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  double cardWidth = (constraints.maxWidth - 40) / 3;
                                  if (cardWidth < 250) {
                                    cardWidth = constraints.maxWidth; // fallback stack vertically if too small
                                  }
                                  
                                  bool wrap = cardWidth == constraints.maxWidth;
                                  
                                  if (wrap) {
                                    return const Column(
                                      children: [
                                        MetricCard(
                                          title: 'Total Active Users',
                                          value: '1,432',
                                          icon: Icons.group,
                                          iconColor: AppColors.primary,
                                          trendIcon: Icons.trending_up,
                                          trendText: '+12% vs last week',
                                        ),
                                        SizedBox(height: 20),
                                        MetricCard(
                                          title: 'Total Storage Used',
                                          value: '845',
                                          suffix: 'TB',
                                          icon: Icons.storage,
                                          iconColor: AppColors.tertiary,
                                          subtitle: '845 TB / 1 PB',
                                          progressValue: 0.845,
                                        ),
                                        SizedBox(height: 20),
                                        MetricCard(
                                          title: 'Active Invitations',
                                          value: '47',
                                          icon: Icons.vpn_key,
                                          iconColor: AppColors.secondary,
                                          subtitle: '12 awaiting activation',
                                        ),
                                      ],
                                    );
                                  }
                                  
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: const MetricCard(
                                          title: 'Total Active Users',
                                          value: '1,432',
                                          icon: Icons.group,
                                          iconColor: AppColors.primary,
                                          trendIcon: Icons.trending_up,
                                          trendText: '+12% vs last week',
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: const MetricCard(
                                          title: 'Total Storage Used',
                                          value: '845',
                                          suffix: 'TB',
                                          icon: Icons.storage,
                                          iconColor: AppColors.tertiary,
                                          subtitle: '845 TB / 1 PB',
                                          progressValue: 0.845,
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: const MetricCard(
                                          title: 'Active Invitations',
                                          value: '47',
                                          icon: Icons.vpn_key,
                                          iconColor: AppColors.secondary,
                                          subtitle: '12 awaiting activation',
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              
                              const SizedBox(height: 24),
                              
                              // Table
                              const RecentActivityTable(),
                              const SizedBox(height: 48), // Bottom padding
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

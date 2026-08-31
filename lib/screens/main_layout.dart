import 'package:flutter/material.dart';
import '../widgets/side_navbar.dart';
import 'dashboard_screen.dart';
import 'invitation_codes_screen.dart';
import 'users_management_screen.dart';
import 'telegram_storage_screen.dart';
import 'settings_screen.dart';

import '../providers/api_provider.dart';
import '../providers/dashboard_provider.dart';
import '../providers/invitation_codes_provider.dart';
import '../providers/users_provider.dart';
import '../providers/telegram_nodes_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'login_screen.dart';

class MainLayout extends ConsumerStatefulWidget {
  const MainLayout({super.key});

  @override
  ConsumerState<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideNavBar(
            selectedIndex: _selectedIndex,
            onItemSelected: (index) async {
              if (index == 99) {
                // Logout
                await ref.read(apiServiceProvider).logout();
                if (!context.mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
                return;
              }
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          Expanded(
            child: Column(
              children: [
                // Top Bar with Global Refresh
                Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFF2C2C2C)),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Refresh'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2C2C2C),
                          foregroundColor: Colors.white,
                          elevation: 0,
                        ),
                        onPressed: () {
                          // Invalidate all main providers to force a refresh
                          ref.invalidate(dashboardProvider);
                          ref.invalidate(invitationCodesProvider);
                          ref.invalidate(usersProvider);
                          ref.invalidate(telegramNodesProvider);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('All data refreshed'),
                              duration: Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _buildCurrentScreen(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_selectedIndex) {
      case 0:
        return const DashboardScreen();
      case 1:
        return const InvitationCodesScreen();
      case 2:
        return const UsersManagementScreen();
      case 3:
        return const TelegramStorageScreen();
      case 4:
        return const SettingsScreen();
      default:
        return const Center(
            child: Text('Screen not implemented yet',
                style: TextStyle(color: Colors.white)));
    }
  }
}

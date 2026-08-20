import 'package:flutter/material.dart';
import '../widgets/side_navbar.dart';
import '../widgets/top_navbar.dart';
import 'dashboard_screen.dart';
import 'invitation_codes_screen.dart';
import 'users_management_screen.dart';
import 'telegram_storage_screen.dart';
import 'settings_screen.dart';

import '../providers/api_provider.dart';
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
                const TopNavBar(),
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
        return const Center(child: Text('Screen not implemented yet', style: TextStyle(color: Colors.white)));
    }
  }
}

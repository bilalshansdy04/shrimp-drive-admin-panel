import 'package:flutter/material.dart';
import '../widgets/side_navbar.dart';
import '../widgets/top_navbar.dart';
import 'dashboard_screen.dart';
import 'invitation_codes_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideNavBar(
            selectedIndex: _selectedIndex,
            onItemSelected: (index) {
              if (index == 99) return; // Ignore logout for now
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
      default:
        return const Center(child: Text('Screen not implemented yet', style: TextStyle(color: Colors.white)));
    }
  }
}

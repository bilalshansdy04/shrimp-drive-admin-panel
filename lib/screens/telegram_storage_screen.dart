import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/storage_card.dart';
import '../widgets/add_storage_card.dart';

class TelegramStorageScreen extends StatelessWidget {
  const TelegramStorageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Telegram Storage & Bots',
                      style: TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Manage your connected Telegram bots and channels for cloud storage.',
                      style: TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add New Storage', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                    foregroundColor: AppColors.surface,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Storage Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: _getCrossAxisCount(context),
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: 0.85, // Adjust this ratio depending on actual height needed
                children: const [
                  StorageCard(
                    title: 'FAMILY STORAGE',
                    icon: Icons.folder_special,
                    botToken: '123456789:AAH...xxxxxxxx',
                    chatId: '-100987654321',
                    isConnected: true,
                  ),
                  StorageCard(
                    title: 'PROJECT X BACKUPS',
                    icon: Icons.folder_shared,
                    botToken: '987654321:BBG...yyyyyyyy',
                    chatId: '-100123456789',
                    isConnected: true,
                  ),
                  AddStorageCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // Assuming side navbar takes ~256px
    double availableWidth = width - 256;
    if (availableWidth > 1024) return 3;
    if (availableWidth > 768) return 2;
    return 1;
  }
}

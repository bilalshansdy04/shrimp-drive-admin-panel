import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../widgets/storage_card.dart';
import '../widgets/add_storage_card.dart';
import '../providers/telegram_nodes_provider.dart';
import '../providers/api_provider.dart';
import '../models/telegram_node.dart';

class TelegramStorageScreen extends ConsumerStatefulWidget {
  const TelegramStorageScreen({super.key});

  @override
  ConsumerState<TelegramStorageScreen> createState() => _TelegramStorageScreenState();
}

class _TelegramStorageScreenState extends ConsumerState<TelegramStorageScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(telegramNodesProvider.notifier).build());
  }

  void _showNodeFormDialog([TelegramNode? node]) {
    final isEditing = node != null;
    final nameCtrl = TextEditingController(text: node?.name ?? '');
    final botTokenCtrl = TextEditingController(text: node?.botToken ?? '');
    final chatIdCtrl = TextEditingController(text: node?.chatId ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceContainerHigh,
          title: Text(isEditing ? 'Edit Storage Node' : 'Add Storage Node', style: const TextStyle(color: AppColors.onSurface)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                style: const TextStyle(color: AppColors.onSurface),
                decoration: const InputDecoration(
                  labelText: 'Name (e.g. Family Storage)',
                  filled: true,
                  fillColor: AppColors.surfaceContainer,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: botTokenCtrl,
                style: const TextStyle(color: AppColors.onSurface),
                decoration: const InputDecoration(
                  labelText: 'Bot Token',
                  filled: true,
                  fillColor: AppColors.surfaceContainer,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: chatIdCtrl,
                style: const TextStyle(color: AppColors.onSurface),
                decoration: const InputDecoration(
                  labelText: 'Chat ID',
                  filled: true,
                  fillColor: AppColors.surfaceContainer,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final data = {
                  'name': nameCtrl.text,
                  'botToken': botTokenCtrl.text,
                  'chatId': chatIdCtrl.text,
                };
                if (isEditing) {
                  await ref.read(telegramNodesProvider.notifier).updateNode(node.id, data);
                } else {
                  await ref.read(telegramNodesProvider.notifier).createNode(data);
                }
                if (context.mounted) {
                  if (ref.read(telegramNodesProvider).hasError) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${ref.read(telegramNodesProvider).error}')));
                  } else {
                    Navigator.pop(context);
                  }
                }
              },
              child: Text(isEditing ? 'Save Changes' : 'Add Node'),
            )
          ],
        );
      },
    );
  }

  void _confirmDelete(TelegramNode node) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceContainerHigh,
          title: const Text('Delete Node?', style: TextStyle(color: AppColors.onSurface)),
          content: Text('Are you sure you want to delete ${node.name}?', style: const TextStyle(color: AppColors.onSurfaceVariant)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.error),
              onPressed: () async {
                await ref.read(telegramNodesProvider.notifier).deleteNode(node.id);
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.white)),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final nodesAsync = ref.watch(telegramNodesProvider);

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
                  onPressed: () => _showNodeFormDialog(),
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
              child: nodesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: AppColors.error))),
                data: (nodes) {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _getCrossAxisCount(context),
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      childAspectRatio: 0.85, 
                    ),
                    itemCount: nodes.length + 1,
                    itemBuilder: (context, index) {
                      if (index == nodes.length) {
                        return AddStorageCard(
                          onTap: () => _showNodeFormDialog(),
                        );
                      }
                      final node = nodes[index];
                      return StorageCard(
                        title: node.name.toUpperCase(),
                        icon: Icons.cloud,
                        botToken: node.botToken,
                        chatId: node.chatId,
                        isConnected: node.isActive,
                        onEdit: () => _showNodeFormDialog(node),
                        onDelete: () => _confirmDelete(node),
                        onTestConnection: () async {
                          try {
                            final title = await ref.read(apiServiceProvider).testTelegramNode(node.botToken, node.chatId);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Connected to: $title')));
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Connection failed. Please check token and chat ID.')));
                            }
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double availableWidth = width - 256;
    if (availableWidth > 1024) return 3;
    if (availableWidth > 768) return 2;
    return 1;
  }
}

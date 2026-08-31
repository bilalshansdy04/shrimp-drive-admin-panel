import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
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
    bool isGlobal = node?.isGlobal ?? false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Set as Global Storage', style: TextStyle(color: AppColors.onSurface)),
                    subtitle: const Text('New users without invite codes will use this storage', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
                    value: isGlobal,
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) => setState(() => isGlobal = val),
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
                      'isGlobal': isGlobal,
                    };
                    if (isEditing) {
                      await ref.read(telegramNodesProvider.notifier).updateNode(node!.id, data);
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
          }
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

  void _showBackupDatabaseDialog() {
    final botTokenCtrl = TextEditingController();
    final chatIdCtrl = TextEditingController();
    bool isBackingUp = false;
    String? selectedNodeId;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final nodesAsync = ref.watch(telegramNodesProvider);
            return AlertDialog(
              backgroundColor: AppColors.surfaceContainerHigh,
              title: const Text('Backup Database to Telegram', style: TextStyle(color: AppColors.onSurface)),
              content: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'This will dump all database tables into a JSON file and send it as a document to the specified Telegram channel.',
                      style: TextStyle(color: AppColors.onSurfaceVariant),
                    ),
                    const SizedBox(height: 16),
                    nodesAsync.maybeWhen(
                      data: (nodes) {
                        return DropdownButton<String?>(
                          value: selectedNodeId,
                          isExpanded: true,
                          hint: const Text('Select Target Node', style: TextStyle(color: AppColors.onSurfaceVariant)),
                          dropdownColor: AppColors.surfaceContainerHigh,
                          style: const TextStyle(color: AppColors.onSurface),
                          items: [
                            const DropdownMenuItem(value: null, child: Text('Custom (Enter manually)')),
                            ...nodes.map((n) => DropdownMenuItem(value: n.id, child: Text(n.name))),
                          ],
                          onChanged: (val) {
                            setState(() => selectedNodeId = val);
                          },
                        );
                      },
                      orElse: () => const SizedBox(),
                    ),
                    if (selectedNodeId == null) ...[
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
                          labelText: 'Admin Chat ID',
                          filled: true,
                          fillColor: AppColors.surfaceContainer,
                        ),
                      ),
                    ],
                    if (isBackingUp) ...[
                      const SizedBox(height: 16),
                      const Center(child: CircularProgressIndicator()),
                    ]
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isBackingUp ? null : () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                FilledButton.icon(
                  onPressed: isBackingUp ? null : () async {
                    setState(() => isBackingUp = true);
                    try {
                      await ref.read(apiServiceProvider).backupDatabaseToTelegram(
                        nodeId: selectedNodeId,
                        botToken: selectedNodeId == null ? botTokenCtrl.text : null,
                        chatId: selectedNodeId == null ? chatIdCtrl.text : null,
                      );
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Database backed up successfully!')),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Backup failed: $e')),
                        );
                      }
                    } finally {
                      if (context.mounted) {
                        setState(() => isBackingUp = false);
                      }
                    }
                  },
                  icon: const Icon(Icons.cloud_upload, size: 18),
                  label: const Text('Backup Now'),
                )
              ],
            );
          }
        );
      },
    );
  }

  void _showRestoreDatabaseDialog() async {
    // We use flutter_file_picker to pick the JSON
    FilePickerResult? result;
    try {
      result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error picking file: $e')));
      }
      return;
    }

    if (result != null && context.mounted) {
      final file = result.files.single;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          bool isRestoring = false;
          return StatefulBuilder(
            builder: (ctx, setState) {
              return AlertDialog(
                backgroundColor: AppColors.surfaceContainerHigh,
                title: const Text('Restore Database', style: TextStyle(color: AppColors.onSurface)),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('File selected: ${file.name}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                    const SizedBox(height: 16),
                    const Text(
                      'Are you sure you want to restore the database?\nThis will merge the data from the backup file. Existing data will NOT be overwritten, only missing data will be inserted.',
                      style: TextStyle(color: AppColors.onSurfaceVariant),
                    ),
                    if (isRestoring) ...[
                      const SizedBox(height: 16),
                      const Center(child: CircularProgressIndicator()),
                    ]
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: isRestoring ? null : () => Navigator.pop(dialogContext),
                    child: const Text('Cancel'),
                  ),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(backgroundColor: AppColors.error),
                    onPressed: isRestoring ? null : () async {
                      setState(() => isRestoring = true);
                      try {
                        final data = file.bytes ?? file.path;
                        await ref.read(apiServiceProvider).restoreDatabase(data, file.name);
                        if (dialogContext.mounted) {
                          Navigator.pop(dialogContext);
                          ScaffoldMessenger.of(dialogContext).showSnackBar(
                            const SnackBar(content: Text('Database restored successfully!')),
                          );
                          // Refresh nodes
                          ref.invalidate(telegramNodesProvider);
                        }
                      } catch (e) {
                        if (dialogContext.mounted) {
                          ScaffoldMessenger.of(dialogContext).showSnackBar(
                            SnackBar(content: Text('Restore failed: $e')),
                          );
                        }
                      } finally {
                        if (dialogContext.mounted) {
                          setState(() => isRestoring = false);
                        }
                      }
                    },
                    icon: const Icon(Icons.restore, size: 18, color: Colors.white),
                    label: const Text('Restore Now', style: TextStyle(color: Colors.white)),
                  )
                ],
              );
            }
          );
        }
      );
    }
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
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 16,
              spacing: 16,
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
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    FilledButton.icon(
                      onPressed: () => _showRestoreDatabaseDialog(),
                      icon: const Icon(Icons.restore, size: 18),
                      label: const Text('Restore DB', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.surfaceContainerHigh,
                        foregroundColor: AppColors.error,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () => _showBackupDatabaseDialog(),
                      icon: const Icon(Icons.backup, size: 18),
                      label: const Text('Backup DB', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.surfaceContainerHigh,
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
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
                        isGlobal: node.isGlobal,
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

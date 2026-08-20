import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/telegram_node.dart';
import 'dashboard_provider.dart';

final telegramNodesProvider = AsyncNotifierProvider<TelegramNodesNotifier, List<TelegramNode>>(() {
  return TelegramNodesNotifier();
});

class TelegramNodesNotifier extends AsyncNotifier<List<TelegramNode>> {
  @override
  Future<List<TelegramNode>> build() async {
    final api = ref.watch(apiServiceProvider);
    return await api.getTelegramNodes();
  }

  Future<void> createNode(Map<String, dynamic> data) async {
    final api = ref.read(apiServiceProvider);
    state = const AsyncValue.loading();
    try {
      await api.createTelegramNode(data);
      ref.invalidateSelf();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateNode(String id, Map<String, dynamic> data) async {
    final api = ref.read(apiServiceProvider);
    state = const AsyncValue.loading();
    try {
      await api.updateTelegramNode(id, data);
      ref.invalidateSelf();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteNode(String id) async {
    final api = ref.read(apiServiceProvider);
    state = const AsyncValue.loading();
    try {
      await api.deleteTelegramNode(id);
      ref.invalidateSelf();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

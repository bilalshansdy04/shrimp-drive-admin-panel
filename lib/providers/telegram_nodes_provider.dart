import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/telegram_node.dart';
import 'api_provider.dart';

final telegramNodesProvider = AsyncNotifierProvider<TelegramNodesNotifier, List<TelegramNode>>(() {
  return TelegramNodesNotifier();
});

class TelegramNodesNotifier extends AsyncNotifier<List<TelegramNode>> {
  @override
  Future<List<TelegramNode>> build() async {
    final api = ref.watch(apiServiceProvider);
    final response = await api.client.get('/telegram-nodes');
    final data = response.data['data'] as List;
    return data.map((json) => TelegramNode.fromJson(json)).toList();
  }

  Future<void> createNode(Map<String, dynamic> data) async {
    final api = ref.read(apiServiceProvider);
    state = const AsyncValue.loading();
    try {
      await api.client.post('/telegram-nodes', data: data);
      ref.invalidateSelf();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateNode(String id, Map<String, dynamic> data) async {
    final api = ref.read(apiServiceProvider);
    state = const AsyncValue.loading();
    try {
      await api.client.patch('/telegram-nodes/$id', data: data);
      ref.invalidateSelf();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteNode(String id) async {
    final api = ref.read(apiServiceProvider);
    state = const AsyncValue.loading();
    try {
      await api.client.delete('/telegram-nodes/$id');
      ref.invalidateSelf();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

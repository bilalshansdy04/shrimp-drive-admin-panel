import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/invitation_code.dart';
import 'api_provider.dart';

final invitationCodesProvider = AsyncNotifierProvider<InvitationCodesNotifier, List<InvitationCode>>(() {
  return InvitationCodesNotifier();
});

class InvitationCodesNotifier extends AsyncNotifier<List<InvitationCode>> {
  @override
  Future<List<InvitationCode>> build() async {
    final api = ref.watch(apiServiceProvider);
    final response = await api.client.get('/invitation-codes');
    final data = response.data as List;
    return data.map((json) => InvitationCode.fromJson(json)).toList();
  }

  Future<void> createCode(Map<String, dynamic> data) async {
    final api = ref.read(apiServiceProvider);
    state = const AsyncValue.loading();
    try {
      await api.client.post('/invitation-codes', data: data);
      // Refresh the list after creation
      ref.invalidateSelf();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateCode(String code, Map<String, dynamic> data) async {
    final api = ref.read(apiServiceProvider);
    state = const AsyncValue.loading();
    try {
      await api.client.patch('/invitation-codes/$code', data: data);
      ref.invalidateSelf();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteCode(String code) async {
    final api = ref.read(apiServiceProvider);
    state = const AsyncValue.loading();
    try {
      await api.client.delete('/invitation-codes/$code');
      ref.invalidateSelf();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> revokeCode(String code) async {
    await updateCode(code, {'isRevoked': true});
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/invitation_code.dart';
import 'dashboard_provider.dart';

final invitationCodesProvider = AsyncNotifierProvider<InvitationCodesNotifier, List<InvitationCode>>(() {
  return InvitationCodesNotifier();
});

class InvitationCodesNotifier extends AsyncNotifier<List<InvitationCode>> {
  @override
  Future<List<InvitationCode>> build() async {
    final api = ref.watch(apiServiceProvider);
    return await api.getInvitationCodes();
  }

  Future<void> createCode(Map<String, dynamic> data) async {
    final api = ref.read(apiServiceProvider);
    state = const AsyncValue.loading();
    try {
      await api.createInvitationCode(data);
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
      await api.updateInvitationCode(code, data);
      ref.invalidateSelf();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteCode(String code) async {
    final api = ref.read(apiServiceProvider);
    state = const AsyncValue.loading();
    try {
      await api.deleteInvitationCode(code);
      ref.invalidateSelf();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> revokeCode(String code) async {
    await updateCode(code, {'isRevoked': true});
  }
}

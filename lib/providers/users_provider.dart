import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import 'api_provider.dart';

final usersProvider = AsyncNotifierProvider<UsersNotifier, List<User>>(() {
  return UsersNotifier();
});

final selectedUserIdProvider = StateProvider<String?>((ref) => null);

final selectedUserProvider = Provider<User?>((ref) {
  final usersState = ref.watch(usersProvider);
  final selectedId = ref.watch(selectedUserIdProvider);
  
  if (selectedId == null) return null;
  
  return usersState.maybeWhen(
    data: (users) => users.cast<User?>().firstWhere(
      (u) => u?.id == selectedId,
      orElse: () => null,
    ),
    orElse: () => null,
  );
});

class UsersNotifier extends AsyncNotifier<List<User>> {
  @override
  Future<List<User>> build() async {
    final api = ref.watch(apiServiceProvider);
    final response = await api.client.get('/users');
    final data = response.data as List;
    return data.map((json) => User.fromJson(json)).toList();
  }

  Future<void> toggleUserStatus(String id, bool currentStatus) async {
    final api = ref.read(apiServiceProvider);
    try {
      final response = await api.client.patch('/users/$id', data: {'isActive': !currentStatus});
      final updatedUser = User.fromJson(response.data);
      state = state.whenData((users) {
        return users.map((u) => u.id == id ? updatedUser : u).toList();
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCustomStorage(String id, int additionalBytes) async {
    final api = ref.read(apiServiceProvider);
    try {
      final response = await api.client.patch('/users/$id', data: {'customStorageBonus': additionalBytes});
      final updatedUser = User.fromJson(response.data);
      state = state.whenData((users) {
        return users.map((u) => u.id == id ? updatedUser : u).toList();
      });
    } catch (e) {
      rethrow;
    }
  }
  
  Future<void> resetPassword(String id, String newPassword) async {
    final api = ref.read(apiServiceProvider);
    try {
      await api.client.patch('/users/$id', data: {'password': newPassword});
    } catch (e) {
      rethrow;
    }
  }
}

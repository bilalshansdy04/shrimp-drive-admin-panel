import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_provider.dart';

final dashboardProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final api = ref.read(apiServiceProvider);
  final response = await api.client.get('/dashboard');
  return response.data as Map<String, dynamic>;
});

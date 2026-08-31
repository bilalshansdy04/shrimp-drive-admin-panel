import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_provider.dart';
export 'api_provider.dart';

final dashboardProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final api = ref.read(apiServiceProvider);
  return api.getDashboard();
});

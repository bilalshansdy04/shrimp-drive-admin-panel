import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  ApiService()
      : _dio = Dio(BaseOptions(
          baseUrl: 'http://localhost:5173/api/admin', // Ganti dengan port backend SvelteKit Anda jika berbeda
          headers: {
            'Authorization': 'Bearer rememberthemagicinsideyou',
          },
        ));

  Future<Map<String, dynamic>> getDashboard() async {
    try {
      final response = await _dio.get('/dashboard');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to load dashboard data: $e');
    }
  }
}

import 'package:dio/dio.dart';
import '../models/invitation_code.dart';

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
  Future<List<InvitationCode>> getInvitationCodes() async {
    try {
      final response = await _dio.get('/invitation-codes');
      final data = response.data as List;
      return data.map((json) => InvitationCode.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load invitation codes: $e');
    }
  }

  Future<InvitationCode> createInvitationCode(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/invitation-codes', data: data);
      return InvitationCode.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create invitation code: $e');
    }
  }

  Future<InvitationCode> updateInvitationCode(String code, Map<String, dynamic> data) async {
    try {
      final response = await _dio.patch('/invitation-codes/$code', data: data);
      return InvitationCode.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update invitation code: $e');
    }
  }

  Future<void> deleteInvitationCode(String code) async {
    try {
      await _dio.delete('/invitation-codes/$code');
    } catch (e) {
      throw Exception('Failed to delete invitation code: $e');
    }
  }
}

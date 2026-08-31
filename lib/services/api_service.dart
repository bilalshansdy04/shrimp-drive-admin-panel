import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/invitation_code.dart';
import '../models/user_model.dart';
import '../models/telegram_node.dart';

class ApiService {
  final Dio _dio;
  String? _token;

  ApiService()
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://drive.shrimp.my.id/api/admin',
          // baseUrl: 'http://localhost:5173/api/admin', // Ganti dengan port backend SvelteKit Anda jika berbeda
        )) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (_token == null) {
          final prefs = await SharedPreferences.getInstance();
          _token = prefs.getString('admin_token');
        }
        if (_token != null) {
          options.headers['Authorization'] = 'Bearer $_token';
        }
        return handler.next(options);
      },
    ));
  }

  Future<void> initToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('admin_token');
  }

  bool get isAuthenticated => _token != null;

  Future<void> login(String username, String password) async {
    try {
      final response = await _dio.post('/login', data: {
        'username': username,
        'password': password,
      });
      final token = response.data['token'];
      if (token != null) {
        _token = token;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('admin_token', token);
      }
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 401) {
        throw Exception('Invalid credentials');
      }
      throw Exception('Failed to login: $e');
    }
  }

  Future<void> logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('admin_token');
  }

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

  Future<InvitationCode> updateInvitationCode(
      String code, Map<String, dynamic> data) async {
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

  // --- Users ---

  Future<List<User>> getUsers() async {
    try {
      final response = await _dio.get('/users');
      final data = response.data as List;
      return data.map((json) => User.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }

  Future<User> updateUser(String id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.patch('/users/$id', data: data);
      return User.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  // --- Telegram Nodes ---

  Future<List<TelegramNode>> getTelegramNodes() async {
    try {
      final response = await _dio.get('/telegram-nodes');
      final data = response.data['data'] as List;
      return data.map((json) => TelegramNode.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load telegram nodes: $e');
    }
  }

  Future<TelegramNode> createTelegramNode(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/telegram-nodes', data: data);
      return TelegramNode.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to create telegram node: $e');
    }
  }

  Future<void> updateTelegramNode(String id, Map<String, dynamic> data) async {
    try {
      await _dio.patch('/telegram-nodes/$id', data: data);
    } catch (e) {
      throw Exception('Failed to update telegram node: $e');
    }
  }

  Future<void> deleteTelegramNode(String id) async {
    try {
      await _dio.delete('/telegram-nodes/$id');
    } catch (e) {
      throw Exception('Failed to delete telegram node: $e');
    }
  }

  Future<String> testTelegramNode(String botToken, String chatId) async {
    try {
      final response = await _dio.post('/telegram-nodes/test', data: {
        'botToken': botToken,
        'chatId': chatId,
      });
      return response.data['data']['chatTitle'] ?? 'Connected';
    } catch (e) {
      throw Exception('Connection failed');
    }
  }

  Future<void> backupDatabaseToTelegram(
      {String? botToken, String? chatId, String? nodeId}) async {
    try {
      final data = <String, dynamic>{};
      if (nodeId != null) {
        data['nodeId'] = nodeId;
      } else {
        data['botToken'] = botToken;
        data['chatId'] = chatId;
      }
      final response = await _dio.post('/backup-db', data: data);
      if (response.data['success'] != true) {
        throw Exception(
            response.data['message'] ?? 'Failed to backup database');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception(
            e.response?.data['message'] ?? 'Failed to backup database');
      }
      throw Exception('Failed to backup database: $e');
    }
  }

  Future<void> restoreDatabase(dynamic fileBytesOrPath, String fileName) async {
    try {
      final formData = FormData.fromMap({
        'file': fileBytesOrPath is String
            ? await MultipartFile.fromFile(fileBytesOrPath, filename: fileName)
            : MultipartFile.fromBytes(fileBytesOrPath as List<int>,
                filename: fileName),
      });
      final response = await _dio.post('/restore-db', data: formData);
      if (response.data['success'] != true) {
        throw Exception(
            response.data['message'] ?? 'Failed to restore database');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception(
            e.response?.data['message'] ?? 'Failed to restore database');
      }
      throw Exception('Failed to restore database: $e');
    }
  }

  // --- Settings ---

  Future<Map<String, String>> getSettings() async {
    try {
      final response = await _dio.get('/settings');
      final data = response.data['data'] as Map<String, dynamic>;
      return data.map((key, value) => MapEntry(key, value.toString()));
    } catch (e) {
      throw Exception('Failed to load settings: $e');
    }
  }

  Future<void> updateSettings(Map<String, dynamic> data) async {
    try {
      await _dio.patch('/settings', data: data);
    } catch (e) {
      throw Exception('Failed to update settings: $e');
    }
  }
}

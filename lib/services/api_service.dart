import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio _dio;
  String? _token;

  ApiService()
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://drive.shrimp.my.id/api/admin',
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
    final apiUrl = prefs.getString('api_url');
    if (apiUrl != null && apiUrl.isNotEmpty) {
      _dio.options.baseUrl = apiUrl;
    }
  }

  Future<void> updateApiUrl(String newUrl) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('api_url', newUrl);
    _dio.options.baseUrl = newUrl;
  }

  String get currentApiUrl => _dio.options.baseUrl;

  Dio get client => _dio;

  bool get isAuthenticated => _token != null;

  Future<bool> testConnection(String url) async {
    try {
      final testDio = Dio(BaseOptions(baseUrl: url, connectTimeout: const Duration(seconds: 5)));
      final response = await testDio.get('/ping');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

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


}

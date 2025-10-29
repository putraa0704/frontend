import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class ApiService {
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.tokenKey);
  }

  static Future<Map<String, String>> _getHeaders({bool needsAuth = false}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (needsAuth) {
      final token = await _getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // Generic GET request
  static Future<Map<String, dynamic>> get(
    String endpoint, {
    bool needsAuth = true,
    Map<String, String>? queryParams,
  }) async {
    try {
      var uri = Uri.parse('${AppConstants.baseUrl}$endpoint');
      
      if (queryParams != null && queryParams.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParams);
      }

      final response = await http.get(
        uri,
        headers: await _getHeaders(needsAuth: needsAuth),
      );

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // Generic POST request
  static Future<Map<String, dynamic>> post(
    String endpoint, {
    required Map<String, dynamic> body,
    bool needsAuth = true,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}$endpoint'),
        headers: await _getHeaders(needsAuth: needsAuth),
        body: jsonEncode(body),
      );

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // Generic PUT request
  static Future<Map<String, dynamic>> put(
    String endpoint, {
    required Map<String, dynamic> body,
    bool needsAuth = true,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('${AppConstants.baseUrl}$endpoint'),
        headers: await _getHeaders(needsAuth: needsAuth),
        body: jsonEncode(body),
      );

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // Generic DELETE request
  static Future<Map<String, dynamic>> delete(
    String endpoint, {
    bool needsAuth = true,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('${AppConstants.baseUrl}$endpoint'),
        headers: await _getHeaders(needsAuth: needsAuth),
      );

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // POST with Multipart (untuk upload file)
  static Future<Map<String, dynamic>> postMultipart(
    String endpoint, {
    required Map<String, String> fields,
    File? file,
    String? fileField = 'foto',
    bool needsAuth = true,
  }) async {
    try {
      final uri = Uri.parse('${AppConstants.baseUrl}$endpoint');
      final request = http.MultipartRequest('POST', uri);

      // Add headers
      if (needsAuth) {
        final token = await _getToken();
        if (token != null) {
          request.headers['Authorization'] = 'Bearer $token';
        }
      }
      request.headers['Accept'] = 'application/json';

      // Add fields
      request.fields.addAll(fields);

      // Add file if exists
      if (file != null && fileField != null) {
        request.files.add(
          await http.MultipartFile.fromPath(fileField, file.path),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // Handle response
  static Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Success
      try {
        return jsonDecode(response.body);
      } catch (e) {
        return {
          'success': true,
          'message': 'Request berhasil',
          'data': response.body,
        };
      }
    } else {
      // Error from server
      try {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Terjadi kesalahan',
          'errors': errorData['errors'],
          'statusCode': response.statusCode,
        };
      } catch (e) {
        return {
          'success': false,
          'message': 'Terjadi kesalahan: ${response.statusCode}',
          'statusCode': response.statusCode,
        };
      }
    }
  }

  // Handle error
  static Map<String, dynamic> _handleError(dynamic error) {
    if (error is SocketException) {
      return {
        'success': false,
        'message': 'Tidak ada koneksi internet',
      };
    } else if (error is HttpException) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan pada server',
      };
    } else if (error is FormatException) {
      return {
        'success': false,
        'message': 'Format response tidak valid',
      };
    } else {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${error.toString()}',
      };
    }
  }
}
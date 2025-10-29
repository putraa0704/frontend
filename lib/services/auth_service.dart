import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../utils/constants.dart';
import 'api_service.dart';

class AuthService {
  // Login
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiService.post(
        AppConstants.loginEndpoint,
        body: {
          'email': email,
          'password': password,
        },
        needsAuth: false,
      );

      if (response['success'] == true) {
        // Save token and user data
        final token = response['data']['token'];
        final userData = response['data']['user'];
        final user = User.fromJson(userData);

        await _saveAuthData(token, user);

        return {
          'success': true,
          'user': user,
          'message': response['message'] ?? 'Login berhasil',
        };
      } else {
        return {
          'success': false,
          'message': response['message'] ?? 'Login gagal',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  // Register
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? rt,
    String? rw,
    String? alamat,
    String? noTelp,
  }) async {
    try {
      final response = await ApiService.post(
        AppConstants.registerEndpoint,
        body: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password,
          if (rt != null) 'rt': rt,
          if (rw != null) 'rw': rw,
          if (alamat != null) 'alamat': alamat,
          if (noTelp != null) 'no_telp': noTelp,
        },
        needsAuth: false,
      );

      if (response['success'] == true) {
        final token = response['data']['token'];
        final userData = response['data']['user'];
        final user = User.fromJson(userData);

        await _saveAuthData(token, user);

        return {
          'success': true,
          'user': user,
          'message': response['message'] ?? 'Registrasi berhasil',
        };
      } else {
        return {
          'success': false,
          'message': response['message'] ?? 'Registrasi gagal',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  // Logout
  static Future<void> logout() async {
    try {
      await ApiService.post(
        AppConstants.logoutEndpoint,
        body: {},
        needsAuth: true,
      );
    } catch (e) {
      // Ignore error, just clear local data
    }

    await _clearAuthData();
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.tokenKey);
    return token != null && token.isNotEmpty;
  }

  // Get current user
  static Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(AppConstants.userKey);

    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }

    return null;
  }

  // Save auth data
  static Future<void> _saveAuthData(String token, User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.tokenKey, token);
    await prefs.setString(AppConstants.userKey, jsonEncode(user.toJson()));
    await prefs.setString(AppConstants.roleKey, user.role);
  }

  // Clear auth data
  static Future<void> _clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
    await prefs.remove(AppConstants.userKey);
    await prefs.remove(AppConstants.roleKey);
  }
}
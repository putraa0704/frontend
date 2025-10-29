import 'dart:io';
import 'package:flutter/material.dart';
import '../models/aduan.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';
import '../models/aduan.dart';


class AduanProvider with ChangeNotifier {
  List<Aduan> _aduanList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Aduan> get aduanList => _aduanList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Get all aduan (for RT/Admin)
  Future<void> getAllAduan({String? status}) async {
    _isLoading = true;
    notifyListeners();

    try {
      Map<String, String>? queryParams;
      if (status != null) {
        queryParams = {'status': status};
      }

      final response = await ApiService.get(
        AppConstants.aduanEndpoint,
        queryParams: queryParams,
      );

      if (response['success'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        _aduanList = data.map((json) => Aduan.fromJson(json)).toList();
        _errorMessage = null;
      } else {
        _errorMessage = response['message'] ?? 'Gagal memuat data';
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Get user's aduan (for Warga)
  Future<void> getMyAduan() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get(AppConstants.wargaAduanEndpoint);

      if (response['success'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        _aduanList = data.map((json) => Aduan.fromJson(json)).toList();
        _errorMessage = null;
      } else {
        _errorMessage = response['message'] ?? 'Gagal memuat data';
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Create aduan
  Future<bool> createAduan({
    required String kategori,
    required String deskripsi,
    required String lokasi,
    File? foto,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.postMultipart(
        AppConstants.aduanEndpoint,
        fields: {
          'kategori': kategori,
          'deskripsi': deskripsi,
          'lokasi': lokasi,
        },
        file: foto,
        fileField: 'foto',
      );

      if (response['success'] == true) {
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
        
        // Refresh list
        await getMyAduan();
        
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Gagal mengirim aduan';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update aduan status (for RT)
  Future<bool> updateAduanStatus({
    required int aduanId,
    required int status,
    String? tanggapan,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.put(
        '${AppConstants.aduanEndpoint}/$aduanId',
        body: {
          'status': status,
          if (tanggapan != null) 'tanggapan': tanggapan,
        },
      );

      if (response['success'] == true) {
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
        
        // Refresh list
        await getAllAduan();
        
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Gagal mengupdate status';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete aduan
  Future<bool> deleteAduan(int aduanId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.delete(
        '${AppConstants.aduanEndpoint}/$aduanId',
      );

      if (response['success'] == true) {
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
        
        // Refresh list
        await getMyAduan();
        
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Gagal menghapus aduan';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Get statistics
  Map<String, int> getStatistics() {
    return {
      'total': _aduanList.length,
      'pending': _aduanList.where((a) => a.status == 1).length,
      'proses': _aduanList.where((a) => a.status == 2).length,
      'selesai': _aduanList.where((a) => a.status == 3).length,
    };
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
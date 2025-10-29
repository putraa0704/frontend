class AppConstants {
  // API Base URL - GANTI INI DENGAN URL BACKEND ANDA
  static const String baseUrl = 'https://coltishly-momentous-gabrielle.ngrok-free.dev';
  
  
  // Endpoints
    static const String loginEndpoint = '/api/login';
  static const String registerEndpoint = '/api/register';
  static const String logoutEndpoint = '/api/logout';
  static const String aduanEndpoint = '/api/aduan';
  static const String wargaAduanEndpoint = '/api/warga/aduan';
  static const String recommendationEndpoint = '/api/admin/recommendations';
  
  // Status
  static const int statusPending = 1;
  static const int statusProses = 2;
  static const int statusSelesai = 3;
  
  // Roles
  static const String roleWarga = 'warga';
  static const String roleRT = 'rt';
  static const String roleAdmin = 'admin';
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String roleKey = 'user_role';
  
  // Status Text
  static String getStatusText(int status) {
    switch (status) {
      case statusPending:
        return 'Pending';
      case statusProses:
        return 'Dalam Proses';
      case statusSelesai:
        return 'Selesai';
      default:
        return 'Unknown';
    }
  }
  
  // Status Color Helper
  static String getStatusColor(int status) {
    switch (status) {
      case statusPending:
        return 'orange';
      case statusProses:
        return 'blue';
      case statusSelesai:
        return 'green';
      default:
        return 'grey';
    }
  }
}
class Aduan {
  final int id;
  final String judul;
  final String deskripsi;
  final String kategori;
  final String lokasi;
  final int status;
  final String? tanggapan;
  final String userName;
  final String createdAt;

  Aduan({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.kategori,
    required this.lokasi,
    required this.status,
    required this.userName,
    required this.createdAt,
    this.tanggapan,
  });

  // Getter tambahan untuk menampilkan status dalam teks
  String get statusText {
    switch (status) {
      case 1:
        return 'Pending';
      case 2:
        return 'Proses';
      case 3:
        return 'Selesai';
      default:
        return 'Tidak diketahui';
    }
  }

  // Convert dari JSON
  factory Aduan.fromJson(Map<String, dynamic> json) {
    return Aduan(
      id: json['id'] ?? 0,
      judul: json['judul'] ?? '',
      deskripsi: json['deskripsi'] ?? json['isi'] ?? '',
      kategori: json['kategori'] ?? '',
      lokasi: json['lokasi'] ?? '',
      status: json['status'] is int ? json['status'] : int.tryParse(json['status'].toString()) ?? 0,
      tanggapan: json['tanggapan'],
      userName: json['user_name'] ?? json['nama_user'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  // Convert ke JSON (opsional)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'deskripsi': deskripsi,
      'kategori': kategori,
      'lokasi': lokasi,
      'status': status,
      'tanggapan': tanggapan,
      'user_name': userName,
      'created_at': createdAt,
    };
  }
}
class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? rt;
  final String? rw;
  final String? alamat;
  final String? noTelp;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.rt,
    this.rw,
    this.alamat,
    this.noTelp,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'warga',
      rt: json['rt'],
      rw: json['rw'],
      alamat: json['alamat'],
      noTelp: json['no_telp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'rt': rt,
      'rw': rw,
      'alamat': alamat,
      'no_telp': noTelp,
    };
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? role,
    String? rt,
    String? rw,
    String? alamat,
    String? noTelp,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      rt: rt ?? this.rt,
      rw: rw ?? this.rw,
      alamat: alamat ?? this.alamat,
      noTelp: noTelp ?? this.noTelp,
    );
  }
}
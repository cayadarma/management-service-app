class Service {
  final int id;
  final String namaBarang;
  final String kerusakan;
  final String spesifikasi;
  final String pemilik;
  final String status;
  final DateTime tanggalMasuk;
  final DateTime? tanggalSelesai;
  final String? imagePath;

  Service({
    required this.id,
    required this.namaBarang,
    required this.kerusakan,
    required this.spesifikasi,
    required this.pemilik,
    required this.status,
    required this.tanggalMasuk,
    this.tanggalSelesai,
    this.imagePath,
  });

  // Factory method untuk membuat objek Service dari Map (hasil query database)
  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      namaBarang: json['nama_barang'],
      kerusakan: json['kerusakan'],
      spesifikasi: json['spesifikasi'],
      pemilik: json['pemilik'],
      status: json['status'],
      tanggalMasuk: DateTime.parse(json['tanggal_masuk']),
      tanggalSelesai: json['tanggal_selesai'] != null
          ? DateTime.parse(json['tanggal_selesai'])
          : null,
      imagePath: json['image_path'],
    );
  }

  // Method untuk mengonversi objek Service ke Map (untuk disimpan di database)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_barang': namaBarang,
      'kerusakan': kerusakan,
      'spesifikasi': spesifikasi,
      'pemilik': pemilik,
      'status': status,
      'tanggal_masuk': tanggalMasuk.toIso8601String(),
      'tanggal_selesai': tanggalSelesai?.toIso8601String(),
      'image_path': imagePath,
    };
  }
}

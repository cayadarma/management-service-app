import 'dart:io';
import 'package:flutter/material.dart';
import '../models/service.dart';
import 'form_screen.dart';
import 'package:provider/provider.dart';
import '../providers/service_provider.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatefulWidget {
  final Service service;

  const DetailScreen({Key? key, required this.service}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Service _service;

  // Inisialisasi state dengan data service yang diterima
  @override
  void initState() {
    super.initState();
    _service = widget.service;
  }

  // Fungsi utama untuk membangun tampilan detail
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Servis',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (_service.imagePath != null && _service.imagePath!.isNotEmpty)
              // Menampilkan gambar dan zoom saat diklik
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => Dialog(
                      backgroundColor: Colors.transparent,
                      child: InteractiveViewer(
                        child: Image.file(File(_service.imagePath!)),
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(_service.imagePath!),
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // Data servis rapi rata kiri dan titik dua sejajar
            Table(
              columnWidths: const {
                0: FixedColumnWidth(130), // lebar label
                1: FlexColumnWidth(),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.top,
              children: [
                _buildDetailRow('Nama Pemilik', _service.pemilik),
                _buildDetailRow('Nama Barang', _service.namaBarang),
                _buildDetailRow('Spesifikasi', _service.spesifikasi),
                _buildDetailRow('Kerusakan', _service.kerusakan),
                _buildDetailRow('Status', _service.status),
                _buildDetailRow('Tanggal Masuk', DateFormat('dd-MM-yyyy').format(_service.tanggalMasuk)),
                _buildDetailRow(
                  'Tanggal Selesai',
                  _service.tanggalSelesai != null
                      ? DateFormat('dd-MM-yyyy').format(_service.tanggalSelesai!)
                      : "-",
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Tombol Edit dan Delete
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE6E7E7),
                      foregroundColor: const Color(0xFF112C4E),
                      minimumSize: const Size.fromHeight(48),
                    ),
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                    // Navigasi ke form edit, lalu update data setelah kembali
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FormScreen(service: _service),
                        ),
                      );
                      if (result != null && result is Service) {
                        setState(() {
                          _service = result;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE6E7E7),
                      foregroundColor: const Color(0xFF112C4E),
                      minimumSize: const Size.fromHeight(48),
                    ),
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                    // Konfirmasi hapus lalu hapus dari provider
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Hapus Servis'),
                          content: const Text('Yakin ingin menghapus data ini?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Hapus'),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        await context.read<ServiceProvider>().deleteService(_service.id);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Ganti _buildDetailRow menjadi:
  TableRow _buildDetailRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(
            '$label',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFFE6E7E7),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                ': ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE6E7E7),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(color: Color(0xFFE6E7E7)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

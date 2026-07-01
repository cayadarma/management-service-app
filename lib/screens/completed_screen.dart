import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/service_provider.dart';
import 'detail_screen.dart';

class CompletedScreen extends StatelessWidget {
  const CompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan Consumer untuk mendapatkan data dari ServiceProvider
    return Consumer<ServiceProvider>(
      builder: (context, provider, child) {
        // Filter data servis yang status-nya "Selesai"
        final completedServices = provider.services.where((s) => s.status == 'Selesai').toList();
        
        return Scaffold(
          backgroundColor: const Color(0xFF112C4E),
          appBar: AppBar(
            title: const Text(
              'Servis Selesai',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFF112C4E),
            foregroundColor: const Color(0xFFE6E7E7),
          ),
          // Jika belum ada servis yang selesai, tampilkan teks info
          body: completedServices.isEmpty
              ? const Center(
                  child: Text('Belum ada servis selesai.', style: TextStyle(color: Colors.white)),
                )
              : ListView.builder(
                  // Tampilkan daftar servis yang selesai
                  itemCount: completedServices.length,
                  itemBuilder: (context, index) {
                    final service = completedServices[index];
                    return Card(
                      color: const Color(0xCC294160),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        // Navigasi ke DetailScreen saat ListTile ditekan
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailScreen(service: service),
                            ),
                          );
                        },
                        // Menampilkan nama barang
                        title: Text(
                          service.namaBarang,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        // Menampilkan pemilik dan status
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Pemilik: ${service.pemilik}', style: const TextStyle(color: Colors.white70)),
                            Text('Status: ${service.status}', style: const TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/service_provider.dart';
import 'form_screen.dart';
import 'detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ServiceProvider>(context);
    final services = provider.services.where((s) => s.status != 'Selesai').toList();

    return Scaffold(
      backgroundColor: const Color(0xFF112C4E),
      appBar: AppBar(
        title: const Text(
          'Rica Servis Elektronik',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF112C4E),
        foregroundColor: const Color(0xFFE6E7E7),
      ),

      body: services.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: const [
                      Icon(Icons.settings, size: 80, color: Color(0xFF8997A8)),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Icon(Icons.settings, size: 30, color: Color(0xFF8997A8)),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Belum ada servis.',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                return Card(
                  color: const Color(0xCC294160),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailScreen(service: service),
                        ),
                      );
                    },
                    title: Text(
                      service.namaBarang,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pemilik: ${service.pemilik}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        Text(
                          'Status: ${service.status}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

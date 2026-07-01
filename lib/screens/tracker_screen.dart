import 'package:flutter/material.dart';

class TrackerScreen extends StatelessWidget {
  const TrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ganti dengan data asli dari provider jika sudah ada
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tracker Servis',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Daftar teknisi dan jumlah barang yang diperbaiki',
          textAlign: TextAlign.center, // pindahkan ke sini!
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}
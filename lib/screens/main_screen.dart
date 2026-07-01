import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tab_index_provider.dart';
import 'home_screen.dart';
import 'completed_screen.dart';
import 'form_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil nilai index tab saat ini dari TabIndexProvider
    final tabProvider = Provider.of<TabIndexProvider>(context);

    return Scaffold(
      // IndexedStack digunakan untuk menjaga state dari masing-masing halaman
      // Hanya halaman dengan index aktif yang ditampilkan
      body: IndexedStack(
        index: tabProvider.index, // Index tab yang sedang aktif
        children: const [
          HomeScreen(),
          CompletedScreen(),
          FormScreen(),
        ],
      ),
      // BottomNavigationBar digunakan untuk navigasi antar tab
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Menjaga posisi tab tidak berubah
        backgroundColor: const Color(0xFF112C4E), 
        selectedItemColor: Colors.white,          
        unselectedItemColor: Colors.white70,      
        currentIndex: tabProvider.index,          
        onTap: tabProvider.changeTab,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Selesai',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Tambah',
          ),
        ],
      ),
    );
  }
}

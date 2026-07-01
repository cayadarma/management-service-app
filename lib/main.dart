import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/service_provider.dart';
import 'providers/tab_index_provider.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ServiceProvider()..loadServices()),
        ChangeNotifierProvider(create: (_) => TabIndexProvider()),
      ],
      child: const MyApp(),
    ),
  );
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Servis Elektronik',
      theme: ThemeData(
        fontFamily: 'Rubik',
        scaffoldBackgroundColor: const Color(0xFF112C4E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF112C4E),
          foregroundColor: Color(0xFFE6E7E7),
          centerTitle: true,
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF112C4E),
          selectedItemColor: Color(0xFFE6E7E7),
          unselectedItemColor: Color(0xFF112C4E),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFFE6E7E7)),
          bodyMedium: TextStyle(color: Color(0xFFE6E7E7)),
          bodySmall: TextStyle(color: Color(0xFFE6E7E7)),
          titleLarge: TextStyle(color: Color(0xFFE6E7E7)),
          titleMedium: TextStyle(color: Color(0xFFE6E7E7)),
          titleSmall: TextStyle(color: Color(0xFFE6E7E7)),
          labelLarge: TextStyle(color: Color(0xFFE6E7E7)),
          labelMedium: TextStyle(color: Color(0xFFE6E7E7)),
          labelSmall: TextStyle(color: Color(0xFFE6E7E7)),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Color(0xFFE6E7E7)),
          hintStyle: TextStyle(color: Color(0xFFE6E7E7)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFE6E7E7)),
            borderRadius: BorderRadius.all(Radius.circular(12)), // <- Tambahkan ini
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFE6E7E7)),
            borderRadius: BorderRadius.all(Radius.circular(12)), // <- Tambahkan ini
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFE6E7E7)),
            borderRadius: BorderRadius.all(Radius.circular(12)), // <- Tambahkan ini
          ),
        ),
        useMaterial3: true,
      ),
      home: const MainScreen(), // arahkan ke halaman utama
    );
  }
}

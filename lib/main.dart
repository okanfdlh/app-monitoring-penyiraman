import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'monitoring_page.dart'; // ganti dengan nama file halaman utama kamu

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cek jika sudah diinisialisasi
  try {
    await Firebase.initializeApp();
  } catch (e) {
    // Abaikan jika sudah terinisialisasi
    print("Firebase sudah diinisialisasi sebelumnya: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MonitoringPage(), // ganti dengan halaman utama kamu
    );
  }
}

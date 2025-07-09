import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'monitoring_page.dart';
import 'firebase_options.dart'; // akan kita buat di bawah

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // penting untuk web
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monitoring Penyiraman',
      debugShowCheckedModeBanner: false,
      home: MonitoringPage(),
    );
  }
}

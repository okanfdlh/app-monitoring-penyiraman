import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: "AIzaSyDqFMh4GVqOs1KYFqfGMjnY-0G1imfI3bw",
      appId: "1:330501322922:android:afbcd3d8644c803c1f78d3",
      messagingSenderId: "330501322922",
      projectId: "kelembabantanah-288f8",
      databaseURL: "https://kelembabantanah-288f8-default-rtdb.asia-southeast1.firebasedatabase.app",
      storageBucket: "kelembabantanah-288f8.firebasestorage.app",
      authDomain: "kelembabantanah-288f8.firebaseapp.com", // untuk web
      measurementId: "G-XXXXXXX", // opsional — boleh kosong atau dihapus
    );
  }
}

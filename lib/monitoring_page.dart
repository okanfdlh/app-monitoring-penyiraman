import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class MonitoringPage extends StatefulWidget {
  const MonitoringPage({super.key});

  @override
  State<MonitoringPage> createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {
  final DatabaseReference _dataRef = FirebaseDatabase.instance.ref('Data');
  final DatabaseReference _historyRef = FirebaseDatabase.instance.ref('History');

  int _kelembaban = 0;
  String _statusPompa = '...';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _dataRef.onValue.listen((event) {
      final data = event.snapshot.value as Map;
      setState(() {
        _kelembaban = data['KelembabanTanah'];
        _statusPompa = data['StatusPompa'];
        _loading = false;
      });
    });
  }

  void _updatePompa(String newStatus) async {
    await _dataRef.update({
      'StatusPompa': newStatus,
    });

    final now = DateTime.now();
    final time = DateFormat('yyyy-MM-dd HH:mm').format(now);

    await _historyRef.push().set({
      'waktu': time,
      'status': newStatus,
    });
  }

  Color _getKelembabanColor() {
    if (_kelembaban >= 70) return Colors.green;
    if (_kelembaban >= 40) return Colors.orange;
    return Colors.red;
  }

  String _getKelembabanStatus() {
    if (_kelembaban >= 70) return "Optimal";
    if (_kelembaban >= 40) return "Sedang";
    return "Rendah";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      appBar: AppBar(
        title: const Text(
          'Smart Plant Care',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
        centerTitle: true,
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF2E7D32),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header dengan greeting
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.local_florist,
                            size: 40,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Status Tanaman Anda',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now()),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Kelembaban Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: _getKelembabanColor().withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.water_drop,
                                  color: _getKelembabanColor(),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Kelembaban Tanah',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2E7D32),
                                    ),
                                  ),
                                  Text(
                                    _getKelembabanStatus(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _getKelembabanColor(),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Text(
                                '$_kelembaban',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: _getKelembabanColor(),
                                ),
                              ),
                              const Spacer(),
                              Container(
                                width: 120,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: _kelembaban / 100,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: _getKelembabanColor(),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Status Pompa Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: (_statusPompa == "HIDUP" ? Colors.green : Colors.red).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  _statusPompa == "HIDUP" ? Icons.water : Icons.power_off,
                                  color: _statusPompa == "HIDUP" ? Colors.green : Colors.red,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Status Pompa Air',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2E7D32),
                                    ),
                                  ),
                                  Text(
                                    _statusPompa == "HIDUP" ? "Sedang menyiram" : "Tidak aktif",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _statusPompa == "HIDUP" ? Colors.green : Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Transform.scale(
                                scale: 1.2,
                                child: Switch(
                                  value: _statusPompa == "HIDUP",
                                  onChanged: (bool value) {
                                    _updatePompa(value ? "HIDUP" : "MATI");
                                  },
                                  activeColor: Colors.white,
                                  activeTrackColor: Colors.green,
                                  inactiveThumbColor: Colors.white,
                                  inactiveTrackColor: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: (_statusPompa == "HIDUP" ? Colors.green : Colors.grey).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              _statusPompa == "HIDUP" 
                                  ? "🌱 Pompa sedang bekerja untuk menyiram tanaman"
                                  : "🌿 Pompa dalam keadaan mati",
                              style: TextStyle(
                                color: _statusPompa == "HIDUP" ? Colors.green : Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 25),
                    
                    // Riwayat Section
                    Row(
                      children: [
                        const Icon(
                          Icons.history,
                          color: Color(0xFF2E7D32),
                          size: 24,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Riwayat Penyiraman",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 15),
                    
                    // History List
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: StreamBuilder<DatabaseEvent>(
                        stream: _historyRef.onValue,
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              snapshot.data!.snapshot.value != null) {
                            final Map data =
                                snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                            final historyList = data.entries.toList()
                              ..sort((a, b) => b.key.compareTo(a.key));

                            return ListView.builder(
                              padding: const EdgeInsets.all(10),
                              itemCount: historyList.length,
                              itemBuilder: (context, index) {
                                final Map<dynamic, dynamic> item = historyList[index].value ?? {};
                                final status = item['status']?.toString() ?? 'Tidak diketahui';
                                final waktu = item['waktu']?.toString() ?? 'Waktu tidak tersedia';
                                final isHidup = status == 'HIDUP';

                                
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: (isHidup ? Colors.green : Colors.red).withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: (isHidup ? Colors.green : Colors.red).withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: (isHidup ? Colors.green : Colors.red).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Icon(
                                          isHidup ? Icons.water_drop : Icons.power_off,
                                          color: isHidup ? Colors.green : Colors.red,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Pompa $status',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: isHidup ? Colors.green : Colors.red,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              waktu,
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          } else {
                            return const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.history,
                                    size: 48,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Belum ada riwayat penyiraman",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../services/narapidana_services.dart';
import 'tambah_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Memanggil service yang sudah kita buat
  final NarapidanaService _narapidanaService = NarapidanaService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Narapidana'),
      ),
      body: StreamBuilder<DatabaseEvent>(
        // Mendengarkan stream dari service
        stream: _narapidanaService.getNarapidanaStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data?.snapshot.value != null) {
            Map<dynamic, dynamic> data =
                snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            
            List<Map<dynamic, dynamic>> listNapi = [];
            data.forEach((key, value) {
              listNapi.add({"key": key, ...value});
            });

            return ListView.builder(
              itemCount: listNapi.length,
              itemBuilder: (context, index) {
                var napi = listNapi[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Icon(
                        napi['jenis_kelamin'] == 'Laki-laki'
                            ? Icons.male
                            : Icons.female,
                      ),
                    ),
                    title: Text('${napi['nama']} (${napi['umur']} Tahun)'),
                    subtitle: Text('Kasus: ${napi['kasus']}'),
                  ),
                );
              },
            );
          }

          return const Center(child: Text('Belum ada data narapidana.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman tambah
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
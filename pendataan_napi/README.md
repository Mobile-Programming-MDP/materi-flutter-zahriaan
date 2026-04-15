<!-- <!
COMMENT FIREBASE Jalankan diCMD
firebase -V (Cek versi firebase)

node -v (Cek node.js kalau belum ada dowload dulu)

1. Comment untuk menginstall firebase secara global
-- npm install -g firebase-tools

2. Comment login firebase
-- firebase login

3. Comment untuk melihat project firebase
-- firebase projects:list

4. Comment membuat project baru firebase
-- firebase projects:create

5. Comment logout firebase account
-- firebase logout


COMNET FLUTTERFIRE Jalankan diTERMINAL VSCODE

Comment install flutterfire secara global
-- dart pub global activate flutterfire_cli

2. Comment untuk menghubungkan project dengan project firebase
-- flutterfire configure

3. Comment download dependency yang di butuhkan
-- flutter pub add firebase_core

--flutter pub add firebase_database
-----------------------------------------------------------------------
-- Buka website "Firebase" lalu pilih "Create a new Firebase project",
setelah itu buat databse sesuai ketentuan soal contoh : "belajaruts".

lalu pilih firebase yang sudah dibuat dan buat "Realtime Database"

lanjut buka "visual studio code"
lalu buat project baru ">f"
contoh saya buat : "pendataan_napi"
---------tunggu loading----------
bukan "..." "Terminal" lalu jalankan diterminal,
#1. flutterfire configure, pilih database yang telah kita buat sebelumnya
contoh yang telah dibuat : "belajaruts" tekan enter, 
lalu pilih "android dan web" ikuti sesuai ketentuan soal.
lalu tekan enter buat dijalankan.
#2.flutter pub add firebase_core, untuk dependency 
#3.flutter pub add firebase_database

codingan yang bisa hapus data
#lib --> services -->narapidana_services.dart
import 'package:firebase_database/firebase_database.dart';

class NarapidanaService {
  // Referensi utama ke node 'narapidana' di database
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('narapidana');

  // Mengambil data secara real-time
  Stream<DatabaseEvent> getNarapidanaStream() {
    return _dbRef.onValue;
  }

  // Menyimpan data baru ke database
  Future<void> tambahNarapidana(Map<String, dynamic> data) async {
    await _dbRef.push().set(data);
  }

  // BARU: Fungsi untuk menghapus data berdasarkan key
  Future<void> hapusNarapidana(String key) async {
    await _dbRef.child(key).remove();
  }
}

#lib --> screens -->home_screen.dart
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
  final NarapidanaService _narapidanaService = NarapidanaService();

  // BARU: Fungsi untuk memunculkan dialog konfirmasi hapus
  void _konfirmasiHapus(String key, String nama) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus data napi bernama $nama?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog jika batal
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                // Panggil fungsi hapus dari service
                _narapidanaService.hapusNarapidana(key).then((_) {
                  Navigator.of(context).pop(); // Tutup dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Data berhasil dihapus')),
                  );
                }).catchError((error) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal menghapus data: $error')),
                  );
                });
              },
              child: const Text(
                'Hapus',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Narapidana'),
      ),
      body: StreamBuilder<DatabaseEvent>(
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
                    // BARU: Menambahkan tombol hapus di sebelah kanan (trailing)
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Memanggil fungsi dialog ketika tombol ditekan
                        _konfirmasiHapus(napi['key'], napi['nama']);
                      },
                    ),
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} --> -->
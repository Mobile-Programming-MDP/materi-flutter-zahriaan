import 'package:flutter/material.dart';
import '../services/narapidana_services.dart';

class TambahScreen extends StatefulWidget {
  const TambahScreen({super.key});

  @override
  State<TambahScreen> createState() => _TambahScreenState();
}

class _TambahScreenState extends State<TambahScreen> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _umurController = TextEditingController();
  final TextEditingController _kasusController = TextEditingController();
  String _jenisKelamin = 'Laki-laki';

  // Memanggil service
  final NarapidanaService _narapidanaService = NarapidanaService();

  void _simpanData() {
    // Validasi form agar tidak kosong
    if (_namaController.text.isEmpty ||
        _umurController.text.isEmpty ||
        _kasusController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi semua bidang!')),
      );
      return;
    }

    // Menyiapkan data dalam bentuk Map
    Map<String, dynamic> dataBaru = {
      'nama': _namaController.text,
      'jenis_kelamin': _jenisKelamin,
      'umur': int.tryParse(_umurController.text) ?? 0,
      'kasus': _kasusController.text,
    };

    // Mengirim data ke Firebase melalui service
    _narapidanaService.tambahNarapidana(dataBaru).then((_) {
      Navigator.pop(context); // Kembali ke HomeScreen setelah berhasil
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan data: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Narapidana')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama Lengkap'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _jenisKelamin,
                decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
                items: ['Laki-laki', 'Perempuan'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _jenisKelamin = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _umurController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Umur (Tahun)'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _kasusController,
                decoration: const InputDecoration(labelText: 'Kasus'),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _simpanData,
                child: const Text('Simpan Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
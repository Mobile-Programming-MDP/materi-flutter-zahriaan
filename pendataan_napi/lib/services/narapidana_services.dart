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
}
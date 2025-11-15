import 'package:flutter/material.dart';
import 'sql_helper.dart'; // Impor file helper yang tadi kita buat

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TP MOD 10 - SQFlite',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List untuk menampung data dari database
  List<Map<String, dynamic>> _dataList = [];
  bool _isLoading = true;

  // Controller untuk TextField
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // (READ) Fungsi untuk mengambil data dari database dan memperbarui UI
  void _refreshData() async {
    setState(() {
      _isLoading = true; // Mulai loading
    });
    final data = await SQLHelper.readItems();
    setState(() {
      _dataList = data;
      _isLoading = false; // Selesai loading
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData(); // Panggil fungsi ini saat aplikasi pertama kali dibuka
  }

  // (CREATE) Fungsi untuk menambahkan item baru
  Future<void> _addItem() async {
    await SQLHelper.addItem(
        _titleController.text, _descriptionController.text);
    _refreshData(); // Perbarui UI setelah data ditambahkan
  }

  // Fungsi untuk menampilkan BottomSheet (Form input)
  // Ini adalah implementasi dari screenshot "Tambah Data Baru"
  void _showForm() {
    // Bersihkan controller setiap kali form dibuka
    _titleController.text = '';
    _descriptionController.text = '';

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true, // Agar tidak tertutup keyboard
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 50,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Tambah Data Baru",
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            // TextField untuk Title (Sesuai Poin 3)
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                  hintText: 'Title', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            // TextField untuk Description (Sesuai Poin 3)
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                  hintText: 'Description', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            // Tombol "Save"
            ElevatedButton(
              onPressed: () async {
                // Simpan data ke database (Sesuai Poin 3)
                await _addItem();
                // Tutup bottom sheet
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TP MOD 10 - SQFlite'),
      ),
      // Tombol (+) untuk menambah data
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(), // Memanggil form input
      ),
      // Menampilkan data (Sesuai Poin 3)
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _dataList.isEmpty
              // Tampilan jika data kosong (Sesuai Screenshot 1)
              ? const Center(
                  child: Text(
                    "Belum ada data",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              // Tampilan jika data ada (Sesuai Screenshot 3)
              : ListView.builder(
                  itemCount: _dataList.length,
                  itemBuilder: (context, index) => Card(
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Menampilkan Title
                          Text(
                            _dataList[index]['title'],
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          // Menampilkan Description
                          Text(_dataList[index]['description']),
                          const SizedBox(height: 8),
                          // Menampilkan Waktu (dari kolom createdAt)
                          Text(
                            _dataList[index]['createdAt'],
                            style: const TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
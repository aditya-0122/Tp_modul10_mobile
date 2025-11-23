import 'package:flutter/material.dart';
import 'api_service.dart'; // API service milik kamu

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TP MOD 11 - SQFlite',
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
  List<Map<String, dynamic>> _dataList = [];
  bool _isLoading = true;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // =======================
  // READ
  // =======================
  void _refreshData() async {
    setState(() => _isLoading = true);

    try {
      final items = await ApiService.fetchItems();
      setState(() {
        _dataList = items.map((e) => {
              "id": e.id,
              "title": e.title,
              "description": e.description,
              "createdAt": e.createdAt ?? "-",
            }).toList();
      });
    } catch (e) {}

    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  // =======================
  // CREATE
  // =======================
  Future<void> _addItem() async {
    await ApiService.addItem(
      _titleController.text,
      _descriptionController.text,
    );
    _refreshData();
  }

  // =======================
  // UPDATE
  // =======================
  Future<void> _updateItem(String id) async {
    await ApiService.updateItem(
      id,
      _titleController.text,
      _descriptionController.text,
    );
    _refreshData();
  }

  // =======================
  // DELETE
  // =======================
  void _deleteItem(String id) async {
    await ApiService.deleteItem(id);
    _refreshData();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Data berhasil dihapus")),
    );
  }

  // =======================
  // FORM ADD & EDIT
  // =======================
  void _showForm(String? id) {
    if (id != null) {
      final existing =
          _dataList.firstWhere((element) => element['id'] == id);

      _titleController.text = existing['title'];
      _descriptionController.text = existing['description'];
    } else {
      _titleController.text = '';
      _descriptionController.text = '';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 5,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 50,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              id == null ? "Tambah Data Baru" : "Edit Data",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 15),

            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                  hintText: "Title", border: OutlineInputBorder()),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                  hintText: "Description", border: OutlineInputBorder()),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                final title = _titleController.text.trim();
                final desc = _descriptionController.text.trim();

                if (title.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Title tidak boleh kosong")),
                  );
                  return;
                }

                try {
                  if (id == null) {
                    await _addItem();
                  } else {
                    await _updateItem(id);
                  }
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Gagal menyimpan data: $e")),
                  );
                }
              },
              child: Text(id == null ? "Save" : "Update"),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TP MOD 11 - SQFlite')),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _dataList.isEmpty
              ? const Center(
                  child: Text(
                    "Belum ada data",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: _dataList.length,
                  itemBuilder: (context, i) => Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _dataList[i]['title'],
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(_dataList[i]['description']),
                                const SizedBox(height: 8),
                                Text(
                                  _dataList[i]['createdAt'],
                                  style: const TextStyle(
                                      fontSize: 10, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showForm(_dataList[i]['id']), 
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteItem(_dataList[i]['id']), 
                            ),
                          ],
                        )
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}

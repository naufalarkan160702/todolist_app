import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'models/kas_model.dart';

void main() {
  runApp(const KasRTApp());
}

class KasRTApp extends StatelessWidget {
  const KasRTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Kas RT',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<KasItem> _kasList = [];
  final _formKey = GlobalKey<FormState>();
  String _selectedJenis = 'Pemasukan';
  final _nominalController = TextEditingController();
  final _keteranganController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _nominalController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  void _tambahKas() {
    if (_formKey.currentState!.validate()) {
      final newItem = KasItem(
        id: const Uuid().v4(),
        jenis: _selectedJenis,
        nominal: double.parse(_nominalController.text),
        keterangan: _keteranganController.text,
        tanggal: _selectedDate,
      );

      setState(() {
        _kasList.add(newItem);
        _nominalController.clear();
        _keteranganController.clear();
        _selectedDate = DateTime.now();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'id', symbol: 'Rp ');
    final formatDate = DateFormat('dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kas RT / Warga'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedJenis,
                    items: const [
                      DropdownMenuItem(value: 'Pemasukan', child: Text('Pemasukan')),
                      DropdownMenuItem(value: 'Pengeluaran', child: Text('Pengeluaran')),
                    ],
                    onChanged: (val) => setState(() => _selectedJenis = val!),
                    decoration: const InputDecoration(labelText: 'Jenis Transaksi'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nominalController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Nominal'),
                    validator: (val) => val == null || val.isEmpty ? 'Isi nominal' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _keteranganController,
                    decoration: const InputDecoration(labelText: 'Keterangan'),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    onPressed: _tambahKas,
                    label: const Text('Tambah'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            Expanded(
              child: _kasList.isEmpty
                  ? const Center(child: Text('Belum ada transaksi.'))
                  : ListView.builder(
                      itemCount: _kasList.length,
                      itemBuilder: (context, index) {
                        final item = _kasList[index];
                        return ListTile(
                          leading: Icon(
                            item.jenis == 'Pemasukan'
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            color: item.jenis == 'Pemasukan' ? Colors.green : Colors.red,
                          ),
                          title: Text(item.keterangan),
                          subtitle: Text(formatDate.format(item.tanggal)),
                          trailing: Text(
                            '${item.jenis == 'Pemasukan' ? '+' : '-'}${formatCurrency.format(item.nominal)}',
                            style: TextStyle(
                              color: item.jenis == 'Pemasukan' ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

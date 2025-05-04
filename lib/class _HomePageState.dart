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
        // 🧾 Form Input Kas
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
        // 📋 List Transaksi
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

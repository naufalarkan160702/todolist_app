class KasItem {
  final String id;
  final String jenis; // "Pemasukan" atau "Pengeluaran"
  final double nominal;
  final String keterangan;
  final DateTime tanggal;

  KasItem({
    required this.id,
    required this.jenis,
    required this.nominal,
    required this.keterangan,
    required this.tanggal,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jenis': jenis,
      'nominal': nominal,
      'keterangan': keterangan,
      'tanggal': tanggal.toIso8601String(),
    };
  }

  factory KasItem.fromMap(Map<String, dynamic> map) {
    return KasItem(
      id: map['id'],
      jenis: map['jenis'],
      nominal: map['nominal'],
      keterangan: map['keterangan'],
      tanggal: DateTime.parse(map['tanggal']),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/karyawan.dart';
import '../helpers/database_helper.dart';

class FormKaryawanPage extends StatefulWidget {
  // null = Tambah, terisi = Edit
  final Karyawan? karyawan;
  const FormKaryawanPage({super.key, this.karyawan});

  @override
  State<FormKaryawanPage> createState() => _FormKaryawanPageState();
}

class _FormKaryawanPageState extends State<FormKaryawanPage> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _pinController = TextEditingController();

  String _peranTerpilih = 'Kasir';
  final List<String> _daftarPeran = ['Kasir', 'Admin', 'Manajer'];

  bool _sedangMenyimpan = false;

  bool get _isEditMode => widget.karyawan != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _namaController.text = widget.karyawan!.namaKaryawan;
      _pinController.text = widget.karyawan!.pin;
      _peranTerpilih = widget.karyawan!.peran;
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _simpanKaryawan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _sedangMenyimpan = true);

    try {
      final dataKaryawan = Karyawan(
        id: _isEditMode ? widget.karyawan!.id : null,
        namaKaryawan: _namaController.text.trim(),
        pin: _pinController.text.trim(),
        peran: _peranTerpilih,
      );

      if (_isEditMode) {
        await DatabaseHelper.instance.updateKaryawan(dataKaryawan);
      } else {
        await DatabaseHelper.instance.insertKaryawan(dataKaryawan);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditMode
                ? 'Data karyawan "${dataKaryawan.namaKaryawan}" berhasil diperbarui!'
                : 'Karyawan baru "${dataKaryawan.namaKaryawan}" berhasil ditambahkan!',
          ),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan database: $e'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _sedangMenyimpan = false);
    }
  }

  InputDecoration _dekor(String label, IconData icon, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      filled: true,
      fillColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          _isEditMode ? 'Edit Data Karyawan' : 'Tambah Staf Kasir Baru',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1E3A8A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Banner info
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.badge_outlined,
                      color: Colors.blue.shade800,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Setiap staf kasir memiliki PIN 4 digit untuk login shift penjualan.',
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Nama
              TextFormField(
                controller: _namaController,
                decoration: _dekor(
                  'Nama Lengkap Karyawan',
                  Icons.person_outline,
                  hint: 'Contoh: Siti Rahmah',
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Nama karyawan wajib diisi!';
                  }
                  if (val.trim().length < 3) {
                    return 'Nama karyawan minimal 3 karakter!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // PIN
              TextFormField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                decoration: _dekor(
                  'PIN Kasir (4 Digit Angka)',
                  Icons.lock_outline,
                  hint: 'Contoh: 1234',
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'PIN kasir wajib diisi!';
                  }
                  if (val.trim().length != 4) {
                    return 'PIN kasir harus tepat 4 digit angka!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Peran
              DropdownButtonFormField<String>(
                value: _peranTerpilih,
                decoration: _dekor('Peran / Jabatan Toko', Icons.work_outline),
                items: _daftarPeran.map((peran) {
                  return DropdownMenuItem<String>(
                    value: peran,
                    child: Text(peran),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _peranTerpilih = val);
                },
              ),
              const SizedBox(height: 28),

              // Tombol simpan
              ElevatedButton.icon(
                onPressed: _sedangMenyimpan ? null : _simpanKaryawan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: _sedangMenyimpan
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Icon(
                        _isEditMode
                            ? Icons.check_circle_outline
                            : Icons.save_outlined,
                      ),
                label: Text(
                  _sedangMenyimpan
                      ? 'Menyimpan Data...'
                      : (_isEditMode
                            ? 'Perbarui Data Karyawan'
                            : 'Simpan Karyawan Baru'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

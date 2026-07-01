import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:uas073/providers/tab_index_provider.dart';
import '../models/service.dart';
import '../providers/service_provider.dart';

class FormScreen extends StatefulWidget {
  final Service? service;
  const FormScreen({Key? key, this.service}) : super(key: key);

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controller untuk form input
  final _namaBarangCtrl = TextEditingController();
  final _kerusakanCtrl = TextEditingController();
  final _spesifikasiCtrl = TextEditingController();
  final _pemilikCtrl = TextEditingController();
  final _tanggalMasukCtrl = TextEditingController();
  final _tanggalSelesaiCtrl = TextEditingController();

  final _statusList = ['Masuk', 'Sedang Diproses', 'Selesai'];
  String _selectedStatus = 'Masuk';

  DateTime? _tanggalMasuk;
  DateTime? _tanggalSelesai;
  File? _imageFile;

  // Fungsi untuk memilih gambar
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 80);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  // Jika mode edit, isi data awal dari service
  @override
  void initState() {
    super.initState();
    if (widget.service != null) {
      _namaBarangCtrl.text = widget.service!.namaBarang;
      _kerusakanCtrl.text = widget.service!.kerusakan;
      _spesifikasiCtrl.text = widget.service!.spesifikasi;
      _pemilikCtrl.text = widget.service!.pemilik;
      _selectedStatus = widget.service!.status;
      _tanggalMasuk = widget.service!.tanggalMasuk;
      _tanggalSelesai = widget.service!.tanggalSelesai;

      _tanggalMasukCtrl.text = _tanggalMasuk != null
          ? DateFormat('dd MMM yyyy').format(_tanggalMasuk!)
          : '';
      _tanggalSelesaiCtrl.text = _tanggalSelesai != null
          ? DateFormat('dd MMM yyyy').format(_tanggalSelesai!)
          : '';

      if (widget.service!.imagePath != null &&
          widget.service!.imagePath!.isNotEmpty) {
        _imageFile = File(widget.service!.imagePath!);
      }
    }
  }

  @override
  void dispose() {
    _namaBarangCtrl.dispose();
    _kerusakanCtrl.dispose();
    _spesifikasiCtrl.dispose();
    _pemilikCtrl.dispose();
    _tanggalMasukCtrl.dispose();
    _tanggalSelesaiCtrl.dispose();
    super.dispose();
  }

  // Fungsi untuk menyimpan form
  void _saveForm() {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<ServiceProvider>();
    final tabProvider = context.read<TabIndexProvider>();

    final newService = Service(
      id: widget.service?.id ?? DateTime.now().millisecondsSinceEpoch,
      namaBarang: _namaBarangCtrl.text.trim(),
      kerusakan: _kerusakanCtrl.text.trim(),
      spesifikasi: _spesifikasiCtrl.text.trim(),
      pemilik: _pemilikCtrl.text.trim(),
      status: _selectedStatus,
      tanggalMasuk: _tanggalMasuk ?? DateTime.now(),
      tanggalSelesai: _tanggalSelesai,
      imagePath: _imageFile?.path,
    );

    if (widget.service == null) {
      provider.addService(newService);
    } else {
      provider.updateService(newService);
    }

    tabProvider.changeTab(0); // pindah ke tab Home
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF112C4E),
      appBar: AppBar(
        title: Text(
          widget.service == null ? 'Tambah Servis' : 'Edit Servis',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF112C4E),
        foregroundColor: const Color(0xFFE6E7E7),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Nama Pemilik
              TextFormField(
                controller: _pemilikCtrl,
                decoration: const InputDecoration(labelText: 'Nama Pemilik'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              // Nama Barang
              TextFormField(
                controller: _namaBarangCtrl,
                decoration: const InputDecoration(labelText: 'Nama Barang'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              // Spesifikasi
              TextFormField(
                controller: _spesifikasiCtrl,
                decoration: const InputDecoration(labelText: 'Spesifikasi'),
              ),
              const SizedBox(height: 16),

              // Kerusakan
              TextFormField(
                controller: _kerusakanCtrl,
                decoration: const InputDecoration(labelText: 'Kerusakan'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              // Dropdown Status
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                items: _statusList.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status,
                        style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value!;
                    if (_selectedStatus != 'Selesai') {
                      _tanggalSelesai = null;
                      _tanggalSelesaiCtrl.text = '';
                    }
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Status',
                  filled: true,
                  fillColor: Color(0xFF112C4E),
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF112C4E)),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                dropdownColor: const Color(0xFF112C4E),
                iconEnabledColor: Colors.white,
              ),
              const SizedBox(height: 16),

              // Tanggal Masuk
              TextFormField(
                controller: _tanggalMasukCtrl,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Tanggal Masuk'),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _tanggalMasuk ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      _tanggalMasuk = picked;
                      _tanggalMasukCtrl.text =
                          DateFormat('dd MMM yyyy').format(picked);
                    });
                  }
                },
                validator: (value) =>
                    value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              // Tanggal Selesai
              TextFormField(
                controller: _tanggalSelesaiCtrl,
                readOnly: true,
                enabled: _selectedStatus == 'Selesai',
                decoration:
                    const InputDecoration(labelText: 'Tanggal Selesai'),
                onTap: _selectedStatus == 'Selesai'
                    ? () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _tanggalSelesai ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() {
                            _tanggalSelesai = picked;
                            _tanggalSelesaiCtrl.text =
                                DateFormat('dd MMM yyyy').format(picked);
                          });
                        }
                      }
                    : null,
              ),
              const SizedBox(height: 24),

              // Gambar (jika ada)
              if (_imageFile != null)
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => Dialog(
                        backgroundColor: Colors.transparent,
                        child: InteractiveViewer(
                          child: Image.file(_imageFile!),
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _imageFile!,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

              // Tombol ambil gambar
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE6E7E7),
                      foregroundColor: const Color(0xFF112C4E),
                    ),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Kamera'),
                    onPressed: () => _pickImage(ImageSource.camera),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE6E7E7),
                      foregroundColor: const Color(0xFF112C4E),
                    ),
                    icon: const Icon(Icons.photo),
                    label: const Text('Galeri'),
                    onPressed: () => _pickImage(ImageSource.gallery),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Tombol Simpan
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE6E7E7),
                  foregroundColor: const Color(0xFF112C4E),
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: _saveForm,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Navigasi ke FormScreen
void navigateToFormScreen(BuildContext context, Service? service) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => FormScreen(service: service),
    ),
  );
}

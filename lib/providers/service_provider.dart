import 'package:flutter/material.dart';
import '../models/service.dart';
import '../helpers/db_helper.dart';

class ServiceProvider extends ChangeNotifier {
  List<Service> _services = [];

  List<Service> get services => _services;

  // Load data dari SQLite
  Future<void> loadServices() async {
    _services = await DBHelper.getServices();
    notifyListeners();
  }

  // Tambah servis
  Future<void> addService(Service service) async {
    await DBHelper.insertService(service);
    await loadServices();
  }

  // Update servis
  Future<void> updateService(Service service) async {
    await DBHelper.updateService(service);
    await loadServices();
  }

  // Hapus servis
  Future<void> deleteService(int id) async {
    await DBHelper.deleteService(id);
    await loadServices();
  }
}

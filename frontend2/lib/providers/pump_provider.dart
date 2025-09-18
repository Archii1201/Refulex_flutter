import 'package:flutter/material.dart';
import '../models/pump_model.dart';
import '../services/pump_service.dart';

class PumpProvider extends ChangeNotifier {
  final PumpService _service = PumpService();
  List<PumpModel> nearby = [];
  bool loading = false;

  Future<void> fetchNearby(double lat, double lng, {int radius = 25000}) async {
    loading = true;
    notifyListeners();
    try {
      nearby = await _service.getNearbyPumps(lat, lng, radiusMeters: radius);
    } catch (e) {
      nearby = [];
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> createPump(String name, double lat, double lng, double price) async {
  try {
    final newPump = await _service.createPump(name, lat, lng, price);
    nearby.add(newPump); // ✅ add new pump to list
    notifyListeners();
  } catch (e) {
    rethrow;
  }
}
}
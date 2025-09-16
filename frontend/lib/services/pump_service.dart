import '../config/api.dart';
import '../models/pump_model.dart';

class PumpService {
  Future<List<PumpModel>> getNearbyPumps(double lat, double lng, {int radiusMeters = 25000}) async {
    final res = await dio.get('/api/pumps/nearby', queryParameters: {'lat': lat, 'lng': lng, 'radius': radiusMeters});
    final data = res.data as List;
    return data.map((e) => PumpModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<PumpModel> getPumpById(String id) async {
    final res = await dio.get('/api/pumps/$id');
    return PumpModel.fromJson(res.data as Map<String, dynamic>);
  }

  Future<PumpModel> createPump(String name, double lat, double lng, double price) async {
    final res = await dio.post('/api/pumps', data: {'name': name, 'lat': lat, 'lng': lng, 'fuelPricePerLitre': price});
    final body = res.data;
    // backend may return pump under key 'pump' or directly
    final pumpJson = body['pump'] ?? body;
    return PumpModel.fromJson(pumpJson as Map<String, dynamic>);
  }
}
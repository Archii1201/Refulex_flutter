import '../config/api.dart';
import '../models/order_model.dart';

class OrderService {
  Future<OrderModel> createOrder({
    String? pumpId,
    required double litres,
    required double customerLat,
    required double customerLng,
  }) async {
    final Map<String, dynamic> payload = {
      'litres': litres,
      'customerLat': customerLat,
      'customerLng': customerLng,
    };

    if (pumpId != null) {
      payload['pumpId'] = pumpId.toString();
    }

    final res = await dio.post('/api/orders', data: payload);

    // backend returns order object at res.data.order or res.data
    final orderJson = (res.data is Map && res.data['order'] != null)
        ? res.data['order']
        : res.data;

    return OrderModel.fromJson(orderJson as Map<String, dynamic>);
  }
}
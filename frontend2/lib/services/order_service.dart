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

    final orderJson = (res.data is Map && res.data['order'] != null)
        ? res.data['order']
        : res.data;

    return OrderModel.fromJson(orderJson as Map<String, dynamic>);
  }

  // ✅ NEW: Fetch all customer orders
  Future<List<OrderModel>> getMyOrders() async {
    final res = await dio.get('/api/orders/my');
    final data = res.data as List;
    return data.map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/order_service.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService _service = OrderService();
  OrderModel? latestOrder;
  bool creating = false;
  bool loadingOrders = false;
  List<OrderModel> orders = [];

  Future<OrderModel?> createOrder({
    String? pumpId,
    required double litres,
    required double lat,
    required double lng,
  }) async {
    creating = true;
    notifyListeners();
    try {
      latestOrder = await _service.createOrder(
        pumpId: pumpId,
        litres: litres,
        customerLat: lat,
        customerLng: lng,
      );
      return latestOrder;
    } catch (e) {
      return null;
    } finally {
      creating = false;
      notifyListeners();
    }
  }

  // ✅ Fetch all orders for logged-in customer
  Future<void> fetchOrders() async {
    loadingOrders = true;
    notifyListeners();
    try {
      orders = await _service.getMyOrders();
    } catch (e) {
      orders = [];
    } finally {
      loadingOrders = false;
      notifyListeners();
    }
  }
}
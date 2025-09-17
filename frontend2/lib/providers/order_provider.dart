import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/order_service.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService _service = OrderService();
  OrderModel? latestOrder;
  bool creating = false;

  Future<OrderModel?> createOrder({String? pumpId, required double litres, required double lat, required double lng}) async {
    creating = true;
    notifyListeners();
    try {
      latestOrder = await _service.createOrder(pumpId: pumpId, litres: litres, customerLat: lat, customerLng: lng);
      return latestOrder;
    } catch (e) {
      return null;
    } finally {
      creating = false;
      notifyListeners();
    }
  }
}
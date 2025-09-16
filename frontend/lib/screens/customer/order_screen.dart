import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/pump_model.dart';
import '../../providers/order_provider.dart';

class OrderScreen extends StatefulWidget {
  final PumpModel pump;
  final double customerLat;
  final double customerLng;

  OrderScreen({required this.pump, required this.customerLat, required this.customerLng});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final litresCtrl = TextEditingController(text: '5');
  bool loading = false;

  void _placeOrder() async {
    setState(() => loading = true);
    final orderProv = Provider.of<OrderProvider>(context, listen: false);
    final order = await orderProv.createOrder(pumpId: widget.pump.id, litres: double.tryParse(litresCtrl.text) ?? 1.0, lat: widget.customerLat, lng: widget.customerLng);
    setState(() => loading = false);
    if (order != null) {
      showDialog(context: context, builder: (_) => AlertDialog(
        title: const Text('Order Placed'),
        content: Text('Total: ₹${order.totalAmount}\nDelivery: ₹${order.deliveryCharge}'),
        actions: [TextButton(onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst), child: const Text('OK'))],
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Order - ${widget.pump.name}')), body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        Text('Price per litre: ₹${widget.pump.fuelPricePerLitre}'),
        const SizedBox(height: 10),
        TextField(controller: litresCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Litres')),
        const SizedBox(height: 20),
        ElevatedButton(onPressed: loading ? null : _placeOrder, child: loading ? CircularProgressIndicator() : const Text('Place Order'))
      ]),
    ));
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';

class OrdersListScreen extends StatefulWidget {
  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<OrderProvider>(context, listen: false).fetchOrders());
  }

  @override
  Widget build(BuildContext context) {
    final orderProv = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: orderProv.loadingOrders
          ? const Center(child: CircularProgressIndicator())
          : orderProv.orders.isEmpty
              ? const Center(child: Text('No orders yet'))
              : ListView.builder(
                  itemCount: orderProv.orders.length,
                  itemBuilder: (ctx, i) {
                    final order = orderProv.orders[i];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(
                            "Order #${order.id.substring(0, 6)} - ${order.status.toUpperCase()}"),
                        subtitle: Text(
                            "Litres: ${order.litres}\nFuel: ₹${order.fuelCost}\nDelivery: ₹${order.deliveryCharge}\nTotal: ₹${order.totalAmount}"),
                        trailing: Text("${order.distanceMeters} m"),
                      ),
                    );
                  },
                ),
    );
  }
}
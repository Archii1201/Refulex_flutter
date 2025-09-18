import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';

class OwnerDashboardScreen extends StatefulWidget {
  const OwnerDashboardScreen({super.key});

  @override
  State<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends State<OwnerDashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<OrderProvider>(context, listen: false).fetchOrders());
  }

  @override
  Widget build(BuildContext context) {
    final orderProv = Provider.of<OrderProvider>(context);

    final totalProfit = orderProv.orders.fold<double>(
        0, (sum, o) => sum + o.totalAmount);
    final pendingOrders =
        orderProv.orders.where((o) => o.status == "pending").toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Owner Dashboard")),
      body: orderProv.loadingOrders
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Card(
                    child: ListTile(
                      title: const Text("💰 Total Profit"),
                      subtitle: Text("₹ $totalProfit"),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: const Text("📦 Pending Orders"),
                      subtitle: Text("${pendingOrders.length} orders"),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: pendingOrders.length,
                      itemBuilder: (ctx, i) {
                        final order = pendingOrders[i];
                        return Card(
                          child: ListTile(
                            title: Text("Order #${order.id.substring(0, 6)}"),
                            subtitle: Text(
                                "Litres: ${order.litres} - Total: ₹${order.totalAmount}"),
                            trailing: Text(order.status.toUpperCase(),
                                style: const TextStyle(color: Colors.orange)),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
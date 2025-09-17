// customer/orders_list_screen.dart
import 'package:flutter/material.dart';

class OrdersListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: const Center(
        child: Text('No orders yet'),
      ),
    );
  }
}
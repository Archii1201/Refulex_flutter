import 'package:flutter/material.dart';
import '../models/pump_model.dart';
import '../screens/customer/order_screen.dart';
import 'package:geolocator/geolocator.dart';

class PumpCard extends StatelessWidget {
  final PumpModel pump;
  const PumpCard({required this.pump});

  Future<Position> _getPos() => Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Position>(
      future: _getPos(),
      builder: (context, snap) {
        final lat = snap.hasData ? snap.data!.latitude : 0.0;
        final lng = snap.hasData ? snap.data!.longitude : 0.0;

        return Padding(padding: const EdgeInsets.all(16.0), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(pump.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Price: ₹${pump.fuelPricePerLitre}/L'),
          const SizedBox(height: 8),
          Row(children: [
            ElevatedButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => OrderScreen(pump: pump, customerLat: lat, customerLng: lng))), child: const Text('Order Fuel')),
            const SizedBox(width: 12),
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
          ])
        ]));
      },
    );
  }
}
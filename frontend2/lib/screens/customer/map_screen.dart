import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../providers/pump_provider.dart';
import '../../models/pump_model.dart';
import '../../widgets/pump_card.dart';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  LatLng? current;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Use default location if permission denied
          setState(() => current = LatLng(28.6139, 77.2090)); // Delhi default
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        // Use default location if permission denied forever
        setState(() => current = LatLng(28.6139, 77.2090)); // Delhi default
        return;
      }

      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() => current = LatLng(pos.latitude, pos.longitude));
      final pumpProv = Provider.of<PumpProvider>(context, listen: false);
      await pumpProv.fetchNearby(pos.latitude, pos.longitude, radius: 25000);
      _setMarkers(pumpProv.nearby);
    } catch (e) {
      print('Error getting location: $e');
      // Use default location on error
      setState(() => current = LatLng(28.6139, 77.2090)); // Delhi default
    }
  }

  void _setMarkers(List<PumpModel> pumps) {
    final set = <Marker>{};
    for (final p in pumps) {
      set.add(Marker(
        markerId: MarkerId(p.id),
        position: LatLng(p.lat, p.lng),
        infoWindow: InfoWindow(title: p.name, snippet: '₹ ${p.fuelPricePerLitre}/L'),
        onTap: () => _showPumpBottomSheet(p),
      ));
    }
    setState(() => markers = set);
  }

  void _showPumpBottomSheet(PumpModel pump) {
    showModalBottomSheet(context: context, builder: (_) => PumpCard(pump: pump));
  }

  @override
  Widget build(BuildContext context) {
    final pumpProv = Provider.of<PumpProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Pumps')),
      body: current == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(target: current!, zoom: 13),
                markers: markers,
                myLocationEnabled: true,
                onMapCreated: (ctrl) => _controller.complete(ctrl),
              ),
              if (pumpProv.loading) const Positioned(top: 16, left: 16, child: CircularProgressIndicator()),
            ]),
    );
  }
}
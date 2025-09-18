import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final latCtrl = TextEditingController();
  final lngCtrl = TextEditingController();

  String role = 'customer';
  bool loading = false;

  Future<void> _register() async {
    setState(() => loading = true);

    try {
      double lat, lng;

      // If user typed location, use that
      if (latCtrl.text.isNotEmpty && lngCtrl.text.isNotEmpty) {
        lat = double.tryParse(latCtrl.text.trim()) ?? 0.0;
        lng = double.tryParse(lngCtrl.text.trim()) ?? 0.0;
      } else {
        // Else, get current location
        final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        lat = pos.latitude;
        lng = pos.longitude;
      }

      final auth = Provider.of<AuthProvider>(context, listen: false);
      final res = await auth.register(
        nameCtrl.text.trim(),
        emailCtrl.text.trim(),
        passCtrl.text.trim(),
        role,
        lat,
        lng,
      );

      setState(() => loading = false);
      if (res['success'] == true) {
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message'] ?? 'Register failed')),
        );
      }
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get location: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: passCtrl,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              DropdownButton<String>(
                value: role,
                items: const [
                  DropdownMenuItem(value: 'customer', child: Text('Customer')),
                  DropdownMenuItem(
                      value: 'pump_owner', child: Text('Pump Owner')),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => role = v);
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: latCtrl,
                decoration: const InputDecoration(
                  labelText: 'Latitude (optional)',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: lngCtrl,
                decoration: const InputDecoration(
                  labelText: 'Longitude (optional)',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: loading ? null : _register,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
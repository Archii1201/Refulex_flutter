import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/pump_provider.dart';

class AddPumpScreen extends StatefulWidget {
  const AddPumpScreen({super.key});

  @override
  State<AddPumpScreen> createState() => _AddPumpScreenState();
}

class _AddPumpScreenState extends State<AddPumpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _latCtrl = TextEditingController();
  final _lngCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();

  bool loading = false;

  Future<void> _savePump() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);
    final pumpProv = Provider.of<PumpProvider>(context, listen: false);

    try {
      await pumpProv.createPump(
        _nameCtrl.text.trim(),
        double.parse(_latCtrl.text),
        double.parse(_lngCtrl.text),
        double.parse(_priceCtrl.text),
      );
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Pump added successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Failed to add pump")),
      );
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Pump")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: "Pump Name"),
              validator: (val) => val!.isEmpty ? "Enter name" : null,
            ),
            TextFormField(
              controller: _latCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Latitude"),
              validator: (val) => val!.isEmpty ? "Enter latitude" : null,
            ),
            TextFormField(
              controller: _lngCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Longitude"),
              validator: (val) => val!.isEmpty ? "Enter longitude" : null,
            ),
            TextFormField(
              controller: _priceCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Fuel Price per Litre"),
              validator: (val) => val!.isEmpty ? "Enter price" : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : _savePump,
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Save Pump"),
            ),
          ]),
        ),
      ),
    );
  }
}
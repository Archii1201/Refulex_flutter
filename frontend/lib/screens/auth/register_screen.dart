import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  String role = 'customer';
  bool loading = false;

  void _register() async {
    setState(() => loading = true);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final res = await auth.register(nameCtrl.text.trim(), emailCtrl.text.trim(), passCtrl.text.trim(), role);
    setState(() => loading = false);
    if (res['success'] == true) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'] ?? 'Register failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
          TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
          TextField(controller: passCtrl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
          DropdownButton<String>(value: role, items: const [
            DropdownMenuItem(value: 'customer', child: Text('Customer')),
            DropdownMenuItem(value: 'pump_owner', child: Text('Pump Owner'))
          ], onChanged: (v) { if (v != null) setState(() => role = v); }),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: loading ? null : _register, child: loading ? CircularProgressIndicator() : const Text('Register')),
        ]),
      ),
    );
  }
}
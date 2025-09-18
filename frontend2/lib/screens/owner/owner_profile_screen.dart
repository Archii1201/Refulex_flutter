import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../customer/edit_profile_screen.dart'; // ✅ fix path

class OwnerProfileScreen extends StatelessWidget {
  const OwnerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () async {
              await auth.logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: const NetworkImage(
                "https://www.w3schools.com/howto/img_avatar.png",
              ),
            ),
            const SizedBox(height: 12),
            Text(
              user?.name ?? "Pump Owner",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              user?.email ?? "",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text("Edit Profile"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EditProfileScreen()), // ✅ removed const
              ),
            ),
          ],
        ),
      ),
    );
  }
}
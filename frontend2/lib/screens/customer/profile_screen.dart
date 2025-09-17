import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () async {
              await auth.logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar
            CircleAvatar(
              radius: 50,
              backgroundImage: const NetworkImage(
                  "https://www.w3schools.com/howto/img_avatar.png"),
            ),
            const SizedBox(height: 16),

            // Name & Role
            Text(
              user?.name ?? "Guest User",
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              user?.role ?? "Customer",
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 12),

            // Email
            Row(
              children: [
                const Icon(Icons.email, size: 20, color: Colors.blueGrey),
                const SizedBox(width: 8),
                Text(user?.email ?? "email@example.com"),
              ],
            ),
            const SizedBox(height: 24),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const EditProfileScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit Profile"),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    await auth.logout();
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
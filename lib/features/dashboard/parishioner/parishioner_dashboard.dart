import 'package:flutter/material.dart';
import '../../auth/auth_repository.dart';
import '../../auth/login_screen.dart';
import '../../../shared/models/user_model.dart';

class ParishionerDashboard extends StatelessWidget {
  final UserModel user;
  const ParishionerDashboard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B4EFF),
        foregroundColor: Colors.white,
        title: const Text('OrdoGital'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthRepository().logout();
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF6B4EFF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mabuhay! 🙏',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.fullName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Parishioner',
                    style: TextStyle(color: Colors.white60, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Mga Serbisyo',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D1B69),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _buildMenuCard(
                    icon: Icons.menu_book,
                    label: 'Daily Readings',
                    color: const Color(0xFF8B5CF6),
                    onTap: () {},
                  ),
                  _buildMenuCard(
                    icon: Icons.schedule,
                    label: 'Mass Schedule',
                    color: const Color(0xFF059669),
                    onTap: () {},
                  ),
                  _buildMenuCard(
                    icon: Icons.campaign,
                    label: 'Announcements',
                    color: const Color(0xFFD97706),
                    onTap: () {},
                  ),
                  _buildMenuCard(
                    icon: Icons.bar_chart,
                    label: 'Parish Projects',
                    color: const Color(0xFFDC2626),
                    onTap: () {},
                  ),
                  _buildMenuCard(
                    icon: Icons.music_note,
                    label: 'Hymns',
                    color: const Color(0xFF0284C7),
                    onTap: () {},
                  ),
                  _buildMenuCard(
                    icon: Icons.quiz,
                    label: 'Liturgical Trivia',
                    color: const Color(0xFF7C3AED),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

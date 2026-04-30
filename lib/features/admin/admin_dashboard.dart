import 'package:flutter/material.dart';
import 'package:ordogital/core/theme/app_theme.dart';
import 'package:ordogital/core/theme/liturgical_season.dart';
import 'package:ordogital/features/admin/admin_login_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final season = LiturgicalCalendar.getCurrentSeason();
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _menuItems = [
    {'icon': Icons.people, 'label': 'User Management'},
    {'icon': Icons.menu_book, 'label': 'Liturgical Content'},
    {'icon': Icons.calendar_month, 'label': 'Mass Scheduler'},
    {'icon': Icons.assignment_ind, 'label': 'Duty Assignment'},
    {'icon': Icons.savings, 'label': 'Financial Tracker'},
    {'icon': Icons.campaign, 'label': 'Announcements'},
    {'icon': Icons.sms, 'label': 'SMS Gateway'},
    {'icon': Icons.music_note, 'label': 'Hymnary'},
  ];

  @override
  Widget build(BuildContext context) {
    final primary = LiturgicalTheme.getPrimaryColor(season);

    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 240,
            color: const Color(0xFF1A2C5B),
            child: Column(
              children: [
                // Logo area
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.church,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'OrdoGital',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Georgia',
                        ),
                      ),
                      const Text(
                        'Admin Portal',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white54,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white24, height: 1),
                const SizedBox(height: 8),
                // Menu items
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    itemCount: _menuItems.length,
                    itemBuilder: (context, index) {
                      final item = _menuItems[index];
                      final isSelected = _selectedIndex == index;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedIndex = index),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white.withValues(alpha: 0.15)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                item['icon'],
                                color: isSelected
                                    ? Colors.white
                                    : Colors.white60,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                item['label'],
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.white60,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(color: Colors.white24, height: 1),
                // Logout
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const AdminLoginScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: const Row(
                      children: [
                        Icon(Icons.logout, color: Colors.white60, size: 20),
                        SizedBox(width: 12),
                        Text(
                          'Logout',
                          style: TextStyle(fontSize: 13, color: Colors.white60),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Main content
          Expanded(
            child: Column(
              children: [
                // Top bar
                Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _menuItems[_selectedIndex]['label'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A2C5B),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Parish Admin',
                          style: TextStyle(
                            fontSize: 13,
                            color: primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Content area
                Expanded(
                  child: Container(
                    color: const Color(0xFFF9FAFB),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _menuItems[_selectedIndex]['icon'],
                            size: 64,
                            color: primary.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _menuItems[_selectedIndex]['label'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: primary.withValues(alpha: 0.5),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Coming soon...',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

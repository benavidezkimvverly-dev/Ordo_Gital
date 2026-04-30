import 'package:flutter/material.dart';
import '../../auth/auth_repository.dart';
import '../../auth/login_screen.dart';
import '../../../shared/models/user_model.dart';
import 'package:ordogital/features/missalette/daily_readings_screen.dart';
import 'package:ordogital/features/missalette/mass_schedule_screen.dart';
import 'package:ordogital/features/announcements/announcements_screen.dart';
import 'package:ordogital/features/transparency/parish_projects_screen.dart';
import 'package:ordogital/features/missalette/hymns_screen.dart';
import 'package:ordogital/features/trivia/trivia_screen.dart';

class ParishionerDashboard extends StatefulWidget {
  final UserModel user;
  const ParishionerDashboard({super.key, required this.user});

  @override
  State<ParishionerDashboard> createState() => _ParishionerDashboardState();
}

class _ParishionerDashboardState extends State<ParishionerDashboard> {
  // Flag para sa toggle ng sidebar
  bool isExpanded = false;

  final Color primaryNavy = const Color(0xFF2A3A66);
  final Color scaffoldBg = const Color(0xFFE8E8E8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBg,
      // Ginagamit natin ang Row para magkatabi ang Sidebar at Content
      body: SafeArea(
        child: Row(
          children: [
            // --- CUSTOM SIDEBAR ---
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isExpanded ? 250 : 70, // Dito nagbabago ang lapad
              color: Colors.white, // Ginawa nating puti para malinis tignan
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  // HAMBURGER BUTTON (Toggle)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: IconButton(
                      icon: Icon(Icons.menu, color: primaryNavy, size: 30),
                      onPressed: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // USER PROFILE (Lilitaw lang pag expanded)
                  if (isExpanded)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: primaryNavy,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              size: 20,
                              color: Color(0xFF2A3A66),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Hello, ${widget.user.fullName}!',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 20),

                  // NAVIGATION ITEMS
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        _sidebarItem(
                          Icons.menu_book,
                          'Daily Readings',
                          const DailyReadingsScreen(),
                        ),
                        _sidebarItem(
                          Icons.schedule,
                          'Mass Schedule',
                          const MassScheduleScreen(),
                        ),
                        _sidebarItem(
                          Icons.campaign,
                          'Announcements',
                          const AnnouncementsScreen(),
                        ),
                        _sidebarItem(
                          Icons.bar_chart,
                          'Parish Projects',
                          const ParishProjectsScreen(),
                        ),
                        _sidebarItem(
                          Icons.music_note,
                          'Hymns',
                          const HymnsScreen(),
                        ),
                        _sidebarItem(
                          Icons.quiz,
                          'Liturgical Trivia',
                          const TriviaScreen(),
                        ),

                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Divider(),
                        ),

                        _sidebarItem(
                          Icons.logout,
                          'Logout',
                          null,
                          isLogout: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // --- MAIN CONTENT AREA ---
            Expanded(
              child: Column(
                children: [
                  // Custom Top Bar (Imbes na default AppBar)
                  Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'OrdoGital Dashboard',
                      style: TextStyle(
                        color: primaryNavy,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Ang laman ng screen mo
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.church_outlined,
                            size: 80,
                            color: primaryNavy.withOpacity(0.2),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Welcome, ${widget.user.fullName}!',
                            style: TextStyle(color: primaryNavy, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function para sa Sidebar Items
  Widget _sidebarItem(
    IconData icon,
    String label,
    Widget? destination, {
    bool isLogout = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: primaryNavy),
      title: isExpanded
          ? Text(
              label,
              style: TextStyle(color: primaryNavy, fontWeight: FontWeight.w500),
            )
          : null,
      onTap: () async {
        if (isLogout) {
          await AuthRepository().logout();
          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          }
        } else if (destination != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => destination),
          );
        }
      },
    );
  }
}

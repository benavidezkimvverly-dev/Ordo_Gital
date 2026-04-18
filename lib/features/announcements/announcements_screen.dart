import 'package:flutter/material.dart';
import 'package:ordogital/core/database/database_helper.dart';
import 'package:ordogital/core/theme/app_theme.dart';
import 'package:ordogital/core/theme/liturgical_season.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  final DatabaseHelper _db = DatabaseHelper.instance;
  List<Map<String, dynamic>> _announcements = [];
  bool _isLoading = true;
  final season = LiturgicalCalendar.getCurrentSeason();

  @override
  void initState() {
    super.initState();
    _loadAnnouncements();
  }

  Future<void> _loadAnnouncements() async {
    final results = await _db.queryWhere(
      'announcements',
      'is_active = ? AND (target_role = ? OR target_role = ?)',
      [1, 'all', 'parishioner'],
    );
    setState(() {
      _announcements = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final primary = LiturgicalTheme.getPrimaryColor(season);
    final background = LiturgicalTheme.getBackgroundColor(season);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        title: const Text('Announcements'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: primary))
          : _announcements.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.campaign_outlined,
                    size: 64,
                    color: primary.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Walang announcements pa.',
                    style: TextStyle(
                      fontSize: 16,
                      color: primary.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pakiusap hintayin ang admin\nna mag-post ng announcements.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: primary.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _announcements.length,
              itemBuilder: (context, index) {
                final announcement = _announcements[index];
                return _buildAnnouncementCard(announcement, primary);
              },
            ),
    );
  }

  Widget _buildAnnouncementCard(
    Map<String, dynamic> announcement,
    Color primary,
  ) {
    final category = announcement['category'] ?? 'general';
    final icon = _getCategoryIcon(category);
    final categoryColor = _getCategoryColor(category);

    return GestureDetector(
      onTap: () => _showAnnouncementDetail(announcement, primary),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: categoryColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          announcement['title'] ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: categoryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          category.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: categoryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    announcement['body'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    announcement['publish_at'] ?? '',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9CA3AF),
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

  void _showAnnouncementDetail(
    Map<String, dynamic> announcement,
    Color primary,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              announcement['title'] ?? '',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              announcement['publish_at'] ?? '',
              style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
            ),
            const SizedBox(height: 16),
            Text(
              announcement['body'] ?? '',
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF374151),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'urgent':
        return Icons.warning_amber;
      case 'feast':
        return Icons.celebration;
      case 'activity':
        return Icons.event;
      default:
        return Icons.campaign;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'urgent':
        return const Color(0xFFDC2626);
      case 'feast':
        return const Color(0xFFD97706);
      case 'activity':
        return const Color(0xFF059669);
      default:
        return const Color(0xFF6B7280);
    }
  }
}

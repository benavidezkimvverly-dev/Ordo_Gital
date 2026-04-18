import 'package:flutter/material.dart';
import 'package:ordogital/core/database/database_helper.dart';
import 'package:ordogital/core/theme/app_theme.dart';
import 'package:ordogital/core/theme/liturgical_season.dart';

class DailyReadingsScreen extends StatefulWidget {
  const DailyReadingsScreen({super.key});

  @override
  State<DailyReadingsScreen> createState() => _DailyReadingsScreenState();
}

class _DailyReadingsScreenState extends State<DailyReadingsScreen> {
  final DatabaseHelper _db = DatabaseHelper.instance;
  Map<String, dynamic>? _reading;
  bool _isLoading = true;
  final season = LiturgicalCalendar.getCurrentSeason();

  @override
  void initState() {
    super.initState();
    _loadReading();
  }

  Future<void> _loadReading() async {
    final today = DateTime.now();
    final dateStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final results = await _db.queryWhere(
      'liturgical_readings',
      'reading_date = ?',
      [dateStr],
    );

    setState(() {
      _reading = results.isNotEmpty ? results.first : null;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final primary = LiturgicalTheme.getPrimaryColor(season);
    final background = LiturgicalTheme.getBackgroundColor(season);
    final seasonName = LiturgicalCalendar.getSeasonName(season);
    final seasonEmoji = LiturgicalTheme.getSeasonEmoji(season);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        title: const Text('Daily Readings'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Season banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Text(seasonEmoji, style: const TextStyle(fontSize: 32)),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              seasonName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _getFormattedDate(),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  if (_reading == null) ...[
                    Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          Icon(
                            Icons.menu_book_outlined,
                            size: 64,
                            color: primary.withValues(alpha: 0.4),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Walang readings para ngayon.',
                            style: TextStyle(
                              fontSize: 16,
                              color: primary.withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Pakiusap hintayin ang admin\nna mag-upload ng readings.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: primary.withValues(alpha: 0.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    _buildReadingCard(
                      title: 'First Reading',
                      content: _reading!['first_reading'] ?? '',
                      icon: Icons.book,
                      primary: primary,
                    ),
                    const SizedBox(height: 12),
                    _buildReadingCard(
                      title: 'Responsorial Psalm',
                      content: _reading!['responsorial'] ?? '',
                      icon: Icons.music_note,
                      primary: primary,
                    ),
                    const SizedBox(height: 12),
                    _buildReadingCard(
                      title: 'Second Reading',
                      content: _reading!['second_reading'] ?? '',
                      icon: Icons.book,
                      primary: primary,
                    ),
                    const SizedBox(height: 12),
                    _buildReadingCard(
                      title: 'Gospel',
                      content: _reading!['gospel'] ?? '',
                      icon: Icons.auto_stories,
                      primary: primary,
                      isGospel: true,
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildReadingCard({
    required String title,
    required String content,
    required IconData icon,
    required Color primary,
    bool isGospel = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isGospel ? primary : const Color(0xFFE5E7EB),
          width: isGospel ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primary, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content.isEmpty ? 'Wala pang laman.' : content,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF374151),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return '${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}, ${now.year}';
  }
}

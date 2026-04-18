import 'package:flutter/material.dart';
import 'package:ordogital/core/database/database_helper.dart';
import 'package:ordogital/core/theme/app_theme.dart';
import 'package:ordogital/core/theme/liturgical_season.dart';

class MassScheduleScreen extends StatefulWidget {
  const MassScheduleScreen({super.key});

  @override
  State<MassScheduleScreen> createState() => _MassScheduleScreenState();
}

class _MassScheduleScreenState extends State<MassScheduleScreen> {
  final DatabaseHelper _db = DatabaseHelper.instance;
  List<Map<String, dynamic>> _schedules = [];
  bool _isLoading = true;
  final season = LiturgicalCalendar.getCurrentSeason();

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    final results = await _db.queryAll('mass_schedules');
    setState(() {
      _schedules = results;
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
        title: const Text('Mass Schedule'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: primary))
          : _schedules.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 64,
                    color: primary.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Walang schedule pa.',
                    style: TextStyle(
                      fontSize: 16,
                      color: primary.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pakiusap hintayin ang admin\nna mag-add ng schedule.',
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
              itemCount: _schedules.length,
              itemBuilder: (context, index) {
                final schedule = _schedules[index];
                return _buildScheduleCard(schedule, primary);
              },
            ),
    );
  }

  Widget _buildScheduleCard(Map<String, dynamic> schedule, Color primary) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.church, color: primary, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  schedule['title'] ?? '',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: primary.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      schedule['mass_time'] ?? '',
                      style: TextStyle(
                        fontSize: 13,
                        color: primary.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: const Color(0xFF9CA3AF),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      schedule['is_recurring'] == 1
                          ? 'Every ${_getDayName(schedule['day_of_week'])}'
                          : schedule['mass_date'] ?? '',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
                if (schedule['notes'] != null &&
                    schedule['notes'].toString().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    schedule['notes'],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getDayName(dynamic dayOfWeek) {
    final days = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];
    if (dayOfWeek == null) return '';
    return days[dayOfWeek % 7];
  }
}

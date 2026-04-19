import 'package:flutter/material.dart';
import 'package:ordogital/core/database/database_helper.dart';
import 'package:ordogital/core/theme/app_theme.dart';
import 'package:ordogital/core/theme/liturgical_season.dart';
import 'package:ordogital/shared/models/user_model.dart';

class DutyScheduleScreen extends StatefulWidget {
  final UserModel user;
  const DutyScheduleScreen({super.key, required this.user});

  @override
  State<DutyScheduleScreen> createState() => _DutyScheduleScreenState();
}

class _DutyScheduleScreenState extends State<DutyScheduleScreen> {
  final DatabaseHelper _db = DatabaseHelper.instance;
  List<Map<String, dynamic>> _duties = [];
  bool _isLoading = true;
  final season = LiturgicalCalendar.getCurrentSeason();

  @override
  void initState() {
    super.initState();
    _loadDuties();
  }

  Future<void> _loadDuties() async {
    final results = await _db.queryWhere('duty_assignments', 'user_id = ?', [
      widget.user.id,
    ]);

    List<Map<String, dynamic>> duties = [];
    for (final duty in results) {
      final schedules = await _db.queryWhere('mass_schedules', 'id = ?', [
        duty['schedule_id'],
      ]);
      if (schedules.isNotEmpty) {
        duties.add({...duty, 'schedule': schedules.first});
      }
    }

    setState(() {
      _duties = duties;
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
        title: const Text('Duty Schedule'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: primary))
          : _duties.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.assignment_outlined,
                    size: 64,
                    color: primary.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Wala kang duty sa ngayon.',
                    style: TextStyle(
                      fontSize: 16,
                      color: primary.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Abangan ang assignment\nmula sa iyong admin.',
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
              itemCount: _duties.length,
              itemBuilder: (context, index) {
                return _buildDutyCard(_duties[index], primary);
              },
            ),
    );
  }

  Widget _buildDutyCard(Map<String, dynamic> duty, Color primary) {
    final schedule = duty['schedule'] as Map<String, dynamic>;
    final isConfirmed = duty['confirmed'] == 1;
    final roleColor = _getRoleColor(duty['role_assigned']);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isConfirmed ? primary : const Color(0xFFE5E7EB),
          width: isConfirmed ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  schedule['title'] ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: roleColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  duty['role_assigned'].toString().toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: roleColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
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
              const SizedBox(width: 16),
              Icon(
                Icons.calendar_today,
                size: 14,
                color: const Color(0xFF9CA3AF),
              ),
              const SizedBox(width: 4),
              Text(
                schedule['mass_date'] ?? '',
                style: const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isConfirmed
                      ? null
                      : () => _confirmDuty(duty['id']),
                  icon: Icon(
                    isConfirmed ? Icons.check_circle : Icons.check,
                    size: 16,
                  ),
                  label: Text(
                    isConfirmed ? 'Confirmed' : 'I-confirm',
                    style: const TextStyle(fontSize: 13),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isConfirmed
                        ? const Color(0xFF16A34A)
                        : primary,
                    side: BorderSide(
                      color: isConfirmed ? const Color(0xFF16A34A) : primary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDuty(int dutyId) async {
    await _db.update('duty_assignments', {'confirmed': 1}, 'id = ?', [dutyId]);
    await _loadDuties();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Duty confirmed! Salamat! 🙏'),
        backgroundColor: Color(0xFF16A34A),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'lector':
        return const Color(0xFF8B5CF6);
      case 'altar_server':
        return const Color(0xFF059669);
      case 'commentator':
        return const Color(0xFF0284C7);
      default:
        return const Color(0xFF6B7280);
    }
  }
}

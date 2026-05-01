import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  final _firestore = FirebaseFirestore.instance;
  final season = LiturgicalCalendar.getCurrentSeason();

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
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('duty_assignments')
            .where('user_access_key', isEqualTo: widget.user.accessKey)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: primary));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
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
            );
          }

          final duties = snapshot.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: duties.length,
            itemBuilder: (context, index) {
              final duty = duties[index];
              final dutyData = duty.data() as Map<String, dynamic>;
              return _buildDutyCard(duty.id, dutyData, primary);
            },
          );
        },
      ),
    );
  }

  Widget _buildDutyCard(
    String dutyId,
    Map<String, dynamic> duty,
    Color primary,
  ) {
    final isConfirmed = duty['confirmed'] == true;
    final roleColor = _getRoleColor(duty['role_assigned'] ?? '');

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
                  duty['mass_title'] ?? 'Mass',
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
                  (duty['role_assigned'] ?? '').toString().toUpperCase(),
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
                duty['mass_time'] ?? '',
                style: TextStyle(
                  fontSize: 13,
                  color: primary.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.calendar_today,
                size: 14,
                color: Color(0xFF9CA3AF),
              ),
              const SizedBox(width: 4),
              Text(
                duty['mass_date'] ?? '',
                style: const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: isConfirmed ? null : () => _confirmDuty(dutyId),
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
    );
  }

  Future<void> _confirmDuty(String dutyId) async {
    await _firestore.collection('duty_assignments').doc(dutyId).update({
      'confirmed': true,
    });

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

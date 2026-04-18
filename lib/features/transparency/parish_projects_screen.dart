import 'package:flutter/material.dart';
import 'package:ordogital/core/database/database_helper.dart';
import 'package:ordogital/core/theme/app_theme.dart';
import 'package:ordogital/core/theme/liturgical_season.dart';

class ParishProjectsScreen extends StatefulWidget {
  const ParishProjectsScreen({super.key});

  @override
  State<ParishProjectsScreen> createState() => _ParishProjectsScreenState();
}

class _ParishProjectsScreenState extends State<ParishProjectsScreen>
    with SingleTickerProviderStateMixin {
  final DatabaseHelper _db = DatabaseHelper.instance;
  List<Map<String, dynamic>> _projects = [];
  bool _isLoading = true;
  final season = LiturgicalCalendar.getCurrentSeason();

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    final results = await _db.queryAll('parish_projects');
    setState(() {
      _projects = results;
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
        title: const Text('Parish Projects'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: primary))
          : _projects.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.construction_outlined,
                    size: 64,
                    color: primary.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Walang projects pa.',
                    style: TextStyle(
                      fontSize: 16,
                      color: primary.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _projects.length,
              itemBuilder: (context, index) {
                return _buildProjectCard(_projects[index], primary);
              },
            ),
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project, Color primary) {
    final goal = (project['goal_amount'] as num).toDouble();
    final current = (project['current_amount'] as num).toDouble();
    final progress = goal > 0 ? (current / goal).clamp(0.0, 1.0) : 0.0;
    final percent = (progress * 100).toStringAsFixed(1);
    final isCompleted = project['is_completed'] == 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted ? primary : const Color(0xFFE5E7EB),
          width: isCompleted ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  project['title'] ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              if (isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Completed',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                ),
            ],
          ),
          if (project['description'] != null &&
              project['description'].toString().isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              project['description'],
              style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            ),
          ],
          const SizedBox(height: 16),
          // Progress bar
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₱${_formatAmount(current)}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: primary,
                        ),
                      ),
                      Text(
                        '${(value * 100).toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: value,
                      minHeight: 12,
                      backgroundColor: primary.withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(primary),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Goal: ₱${_formatAmount(goal)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }
}

import 'package:flutter/material.dart';
import 'package:ordogital/core/database/database_helper.dart';
import 'package:ordogital/core/theme/app_theme.dart';
import 'package:ordogital/core/theme/liturgical_season.dart';

class HymnsScreen extends StatefulWidget {
  const HymnsScreen({super.key});

  @override
  State<HymnsScreen> createState() => _HymnsScreenState();
}

class _HymnsScreenState extends State<HymnsScreen> {
  final DatabaseHelper _db = DatabaseHelper.instance;
  List<Map<String, dynamic>> _hymns = [];
  List<Map<String, dynamic>> _filtered = [];
  bool _isLoading = true;
  final season = LiturgicalCalendar.getCurrentSeason();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadHymns();
  }

  Future<void> _loadHymns() async {
    final results = await _db.queryAll('hymns');
    setState(() {
      _hymns = results;
      _filtered = results;
      _isLoading = false;
    });
  }

  void _onSearch(String query) {
    setState(() {
      _filtered = _hymns
          .where(
            (h) => h['title'].toString().toLowerCase().contains(
              query.toLowerCase(),
            ),
          )
          .toList();
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
        title: const Text('Hymns'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: primary))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearch,
                    decoration: InputDecoration(
                      hintText: 'Maghanap ng kanta...',
                      prefixIcon: Icon(Icons.search, color: primary),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _filtered.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.music_off,
                                size: 64,
                                color: primary.withValues(alpha: 0.4),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Walang kantang nahanap.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: primary.withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _filtered.length,
                          itemBuilder: (context, index) {
                            return _buildHymnCard(_filtered[index], primary);
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildHymnCard(Map<String, dynamic> hymn, Color primary) {
    return GestureDetector(
      onTap: () => _showHymnDetail(hymn, primary),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.music_note, color: primary, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hymn['title'] ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      if (hymn['category'] != null) ...[
                        Text(
                          hymn['category'].toString().toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            color: primary.withValues(alpha: 0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        hymn['language'] ?? 'Filipino',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: primary.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }

  void _showHymnDetail(Map<String, dynamic> hymn, Color primary) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
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
                hymn['title'] ?? '',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${hymn['category']?.toString().toUpperCase() ?? ''} • ${hymn['language'] ?? 'Filipino'}',
                style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Text(
                    hymn['lyrics'] ?? 'Walang lyrics.',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF374151),
                      height: 1.8,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:ordogital/core/database/database_helper.dart';
import 'package:ordogital/core/theme/app_theme.dart';
import 'package:ordogital/core/theme/liturgical_season.dart';

class TriviaScreen extends StatefulWidget {
  const TriviaScreen({super.key});

  @override
  State<TriviaScreen> createState() => _TriviaScreenState();
}

class _TriviaScreenState extends State<TriviaScreen> {
  final DatabaseHelper _db = DatabaseHelper.instance;
  List<Map<String, dynamic>> _questions = [];
  bool _isLoading = true;
  int _currentIndex = 0;
  String? _selectedAnswer;
  bool _answered = false;
  int _score = 0;
  bool _finished = false;
  final season = LiturgicalCalendar.getCurrentSeason();

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final results = await _db.queryAll('trivia_questions');
    setState(() {
      _questions = results;
      _isLoading = false;
    });
  }

  void _selectAnswer(String answer) {
    if (_answered) return;
    final correct = _questions[_currentIndex]['correct_option'];
    setState(() {
      _selectedAnswer = answer;
      _answered = true;
      if (answer == correct) _score++;
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _answered = false;
      });
    } else {
      setState(() => _finished = true);
    }
  }

  void _restart() {
    setState(() {
      _currentIndex = 0;
      _selectedAnswer = null;
      _answered = false;
      _score = 0;
      _finished = false;
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
        title: const Text('Liturgical Trivia'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: primary))
          : _questions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.quiz_outlined,
                    size: 64,
                    color: primary.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Walang trivia questions pa.',
                    style: TextStyle(
                      fontSize: 16,
                      color: primary.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            )
          : _finished
          ? _buildFinishedScreen(primary)
          : _buildQuizScreen(primary),
    );
  }

  Widget _buildQuizScreen(Color primary) {
    final question = _questions[_currentIndex];
    final options = {
      'a': question['option_a'],
      'b': question['option_b'],
      'c': question['option_c'],
      'd': question['option_d'],
    };
    final correct = question['correct_option'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${_currentIndex + 1} of ${_questions.length}',
                style: TextStyle(
                  fontSize: 13,
                  color: primary.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Score: $_score',
                style: TextStyle(
                  fontSize: 13,
                  color: primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (_currentIndex + 1) / _questions.length,
              minHeight: 6,
              backgroundColor: primary.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(primary),
            ),
          ),
          const SizedBox(height: 24),
          // Question card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              question['question'] ?? '',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Options
          ...options.entries.map((entry) {
            final isSelected = _selectedAnswer == entry.key;
            final isCorrect = entry.key == correct;
            Color optionColor = Colors.white;
            Color borderColor = const Color(0xFFE5E7EB);
            Color textColor = const Color(0xFF1F2937);

            if (_answered) {
              if (isCorrect) {
                optionColor = const Color(0xFFDCFCE7);
                borderColor = const Color(0xFF16A34A);
                textColor = const Color(0xFF15803D);
              } else if (isSelected && !isCorrect) {
                optionColor = const Color(0xFFFEE2E2);
                borderColor = const Color(0xFFDC2626);
                textColor = const Color(0xFFDC2626);
              }
            } else if (isSelected) {
              optionColor = primary.withValues(alpha: 0.1);
              borderColor = primary;
              textColor = primary;
            }

            return GestureDetector(
              onTap: () => _selectAnswer(entry.key),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: optionColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: borderColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          entry.key.toUpperCase(),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: borderColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        entry.value ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: textColor,
                          fontWeight: isCorrect && _answered
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    if (_answered && isCorrect)
                      const Icon(
                        Icons.check_circle,
                        color: Color(0xFF16A34A),
                        size: 20,
                      ),
                    if (_answered && isSelected && !isCorrect)
                      const Icon(
                        Icons.cancel,
                        color: Color(0xFFDC2626),
                        size: 20,
                      ),
                  ],
                ),
              ),
            );
          }),
          if (_answered) ...[
            if (question['explanation'] != null &&
                question['explanation'].toString().isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primary.withValues(alpha: 0.2)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, color: primary, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        question['explanation'],
                        style: TextStyle(
                          fontSize: 13,
                          color: primary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _nextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _currentIndex < _questions.length - 1
                      ? 'Susunod na Tanong'
                      : 'Tingnan ang Score',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFinishedScreen(Color primary) {
    final percentage = (_score / _questions.length * 100).toInt();
    String message;
    IconData icon;

    if (percentage >= 80) {
      message = 'Napakahusay! 🎉';
      icon = Icons.emoji_events;
    } else if (percentage >= 60) {
      message = 'Magaling! 👏';
      icon = Icons.thumb_up;
    } else {
      message = 'Subukan ulit! 💪';
      icon = Icons.refresh;
    }

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: primary),
          const SizedBox(height: 20),
          Text(
            message,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$_score / ${_questions.length}',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$percentage% tama',
            style: const TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _restart,
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Maglaro Ulit',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

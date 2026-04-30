import 'package:flutter/material.dart';
import 'package:ordogital/core/theme/liturgical_season.dart';
import 'package:ordogital/features/auth/auth_repository.dart';
import 'package:ordogital/shared/models/user_model.dart';
import 'package:ordogital/features/dashboard/parishioner/parishioner_dashboard.dart';
import 'package:ordogital/features/dashboard/ministry/ministry_dashboard.dart';
import 'package:ordogital/core/theme/app_theme.dart';
import 'package:ordogital/features/auth/welcome_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final AuthRepository _authRepo = AuthRepository();
  final TextEditingController _inputController = TextEditingController();
  final season = LiturgicalCalendar.getCurrentSeason();

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<String> _images = [
    'assets/images/Lictin_church.png',
    'assets/images/church_pic.png',
    'assets/images/church_pic1.png',
    'assets/images/church_pic2.png',
  ];

  int _currentImageIndex = 0;
  int _nextImageIndex = 1;

  bool _isLoading = false;
  bool _obscureText = true;
  bool _showMinistryInput = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _startSlideshow();
  }

  void _startSlideshow() {
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      _fadeController.forward().then((_) {
        if (!mounted) return;
        setState(() {
          _currentImageIndex = _nextImageIndex;
          _nextImageIndex = (_nextImageIndex + 1) % _images.length;
        });
        _fadeController.reset();
        _startSlideshow();
      });
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _handleParishioner() async {
    setState(() => _isLoading = true);
    final user = await _authRepo.loginParishioner();
    await _authRepo.saveSession(user);
    setState(() => _isLoading = false);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => WelcomeScreen(user: user)),
    );
  }

  Future<void> _handleMinistryLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    final user = await _authRepo.loginMinistry(_inputController.text.trim());
    if (user == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Hindi mahanap ang Access Key. Subukan ulit.';
      });
      return;
    }
    await _authRepo.saveSession(user);
    setState(() => _isLoading = false);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => MinistryDashboard(user: user)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Plain background
          Container(color: const Color(0xFFEAEEF2)),
          // Church image — nasa baba, may fade sa taas
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.6,
            child: AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    ShaderMask(
                      shaderCallback: (rect) => const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.white],
                        stops: [0.0, 0.3],
                      ).createShader(rect),
                      blendMode: BlendMode.dstIn,
                      child: Image.asset(
                        _images[_currentImageIndex],
                        fit: BoxFit.cover,
                        alignment: const Alignment(0.0, -0.5),
                      ),
                    ),
                    Opacity(
                      opacity: _fadeAnimation.value,
                      child: ShaderMask(
                        shaderCallback: (rect) => const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.white],
                          stops: [0.0, 0.3],
                        ).createShader(rect),
                        blendMode: BlendMode.dstIn,
                        child: Image.asset(
                          _images[_nextImageIndex],
                          fit: BoxFit.cover,
                          alignment: const Alignment(0.0, -0.5),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          // Content — laging nakasentro sa gitna ng screen
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  const Text(
                    'OrdoGital',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A2C5B),
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Georgia',
                      shadows: [
                        Shadow(
                          blurRadius: 6,
                          color: Colors.white70,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Parish Digital Companion',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF2D3F6B),
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Georgia',
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Floating icons
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _FloatingIcon(emoji: '⭐', delay: Duration.zero),
                      const SizedBox(width: 12),
                      _FloatingIcon(
                        emoji: '🕯️',
                        delay: const Duration(milliseconds: 300),
                      ),
                      const SizedBox(width: 12),
                      _FloatingIcon(
                        emoji: '✝️',
                        delay: const Duration(milliseconds: 600),
                      ),
                      const SizedBox(width: 12),
                      _FloatingIcon(
                        emoji: '🌿',
                        delay: const Duration(milliseconds: 900),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  // ── Buttons OR Ministry Input — laging nandito, hindi gumagalaw ──
                  if (!_showMinistryInput) ...[
                    _buildRoleButton(
                      label: 'Parishioner',
                      onTap: _isLoading ? null : _handleParishioner,
                      isLoading: _isLoading,
                    ),
                    const SizedBox(height: 16),
                    _buildRoleButton(
                      label: 'Ministry Member',
                      onTap: _isLoading
                          ? null
                          : () => setState(() => _showMinistryInput = true),
                    ),
                  ] else ...[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF1A2C5B).withValues(alpha: 0.3),
                        ),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ministry Member Access',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A2C5B),
                              fontFamily: 'Georgia',
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _inputController,
                            obscureText: _obscureText,
                            style: const TextStyle(color: Color(0xFF1A2C5B)),
                            decoration: InputDecoration(
                              hintText: 'Ilagay ang Access Key',
                              hintStyle: TextStyle(
                                color: const Color(
                                  0xFF1A2C5B,
                                ).withValues(alpha: 0.5),
                              ),
                              filled: true,
                              fillColor: Colors.white.withValues(alpha: 0.8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: const Color(
                                    0xFF1A2C5B,
                                  ).withValues(alpha: 0.3),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: const Color(
                                    0xFF1A2C5B,
                                  ).withValues(alpha: 0.3),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xFF1A2C5B),
                                  width: 1.5,
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: const Color(0xFF1A2C5B),
                                ),
                                onPressed: () => setState(
                                  () => _obscureText = !_obscureText,
                                ),
                              ),
                            ),
                          ),
                          if (_errorMessage != null) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.red.withValues(alpha: 0.4),
                                ),
                              ),
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  color: Color(0xFFDC2626),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () => setState(() {
                                    _showMinistryInput = false;
                                    _errorMessage = null;
                                    _inputController.clear();
                                  }),
                                  child: const Text(
                                    'Back',
                                    style: TextStyle(color: Color(0xFF1A2C5B)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 2,
                                child: ElevatedButton(
                                  onPressed: _isLoading
                                      ? null
                                      : _handleMinistryLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1A2C5B),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          'Login',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleButton({
    required String label,
    VoidCallback? onTap,
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF1A2C5B).withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Color(0xFF1A2C5B),
                    strokeWidth: 2,
                  ),
                ),
              )
            : Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A2C5B),
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Georgia',
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }
}

// ✨ Floating Icon Widget
class _FloatingIcon extends StatefulWidget {
  final String emoji;
  final Duration delay;

  const _FloatingIcon({required this.emoji, required this.delay});

  @override
  State<_FloatingIcon> createState() => _FloatingIconState();
}

class _FloatingIconState extends State<_FloatingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _animation = Tween<double>(
      begin: 0,
      end: -8,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    Future.delayed(widget.delay, () {
      if (mounted) _controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: Text(widget.emoji, style: const TextStyle(fontSize: 22)),
        );
      },
    );
  }
}

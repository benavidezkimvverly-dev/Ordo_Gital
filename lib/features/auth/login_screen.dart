import 'package:flutter/material.dart';
import 'package:ordogital/core/theme/liturgical_season.dart';
import 'package:ordogital/features/auth/auth_repository.dart';
import 'package:ordogital/shared/models/user_model.dart';
import 'package:ordogital/features/dashboard/parishioner/parishioner_dashboard.dart';
import 'package:ordogital/features/dashboard/ministry/ministry_dashboard.dart';
import 'package:ordogital/core/theme/app_theme.dart';
import 'package:ordogital/core/theme/liturgical_season.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthRepository _authRepo = AuthRepository();
  final TextEditingController _inputController = TextEditingController();

  String _selectedRole = 'parishioner';
  bool _isLoading = false;
  bool _obscureText = true;
  String? _errorMessage;

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    UserModel? user;

    if (_selectedRole == 'ministry') {
      user = await _authRepo.loginMinistry(_inputController.text.trim());
    } else {
      user = await _authRepo.loginParishioner();
    }

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

    if (user.role == 'parishioner') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ParishionerDashboard(user: user!),
        ),
      );
    } else if (user.role == 'ministry') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MinistryDashboard(user: user!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LiturgicalTheme.getBackgroundColor(
        LiturgicalCalendar.getCurrentSeason(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFF6B4EFF),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(Icons.church, color: Colors.white, size: 48),
              ),
              const SizedBox(height: 20),
              const Text(
                'OrdoGital',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D1B69),
                ),
              ),
              const Text(
                'Parish Digital Companion',
                style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  children: [
                    _buildRoleTab('parishioner', 'Parishioner'),
                    _buildRoleTab('ministry', 'Ministry'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              if (_selectedRole != 'parishioner') ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Access Key',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF374151),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _inputController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    hintText: 'Ilagay ang Access Key',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF6B4EFF),
                        width: 2,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: const Color(0xFF9CA3AF),
                      ),
                      onPressed: () =>
                          setState(() => _obscureText = !_obscureText),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              if (_errorMessage != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                      color: Color(0xFFDC2626),
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B4EFF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          _selectedRole == 'parishioner'
                              ? 'Pumasok bilang Parishioner'
                              : 'Mag-login',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
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

  Widget _buildRoleTab(String role, String label) {
    final isSelected = _selectedRole == role;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _selectedRole = role;
          _inputController.clear();
          _errorMessage = null;
        }),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF6B4EFF) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF6B7280),
            ),
          ),
        ),
      ),
    );
  }
}

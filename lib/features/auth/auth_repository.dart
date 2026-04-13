import 'package:shared_preferences/shared_preferences.dart';
import '../../core/database/database_helper.dart';
import '../../shared/models/user_model.dart';

class AuthRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;

  // Admin login — gamit ang password
  Future<UserModel?> loginAdmin(String password) async {
    // Default admin password: 'admin123'
    // Palitan mo ito later ng mas secure
    if (password != 'admin123') return null;

    final result = await _db.queryWhere('users', 'role = ? AND is_active = ?', [
      'admin',
      1,
    ]);

    if (result.isEmpty) return null;
    return UserModel.fromMap(result.first);
  }

  // Ministry Member login — gamit ang Access Key
  Future<UserModel?> loginMinistry(String accessKey) async {
    final result = await _db.queryWhere(
      'users',
      'access_key = ? AND role = ? AND is_active = ?',
      [accessKey, 'ministry', 1],
    );

    if (result.isEmpty) return null;
    return UserModel.fromMap(result.first);
  }

  // Parishioner — walang login, guest access lang
  Future<UserModel> loginParishioner() async {
    final result = await _db.queryWhere('users', 'role = ? AND is_active = ?', [
      'parishioner',
      1,
    ]);

    if (result.isEmpty) {
      // Gumawa ng guest parishioner account
      final id = await _db.insert('users', {
        'full_name': 'Guest Parishioner',
        'role': 'parishioner',
        'is_active': 1,
      });

      return UserModel(
        id: id,
        fullName: 'Guest Parishioner',
        role: 'parishioner',
      );
    }

    return UserModel.fromMap(result.first);
  }

  // I-save ang logged in user sa SharedPreferences
  Future<void> saveSession(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', user.id!);
    await prefs.setString('user_role', user.role);
    await prefs.setString('user_name', user.fullName);
  }

  // Kunin ang current session
  Future<UserModel?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    final userRole = prefs.getString('user_role');
    final userName = prefs.getString('user_name');

    if (userId == null || userRole == null) return null;

    return UserModel(id: userId, fullName: userName ?? '', role: userRole);
  }

  // Logout — burahin ang session
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/models/user_model.dart';

class AuthRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Ministry Member login — Firestore na
  Future<UserModel?> loginMinistry(String accessKey) async {
    try {
      final result = await _firestore
          .collection('users')
          .where('access_key', isEqualTo: accessKey)
          .where('role', isEqualTo: 'ministry')
          .where('is_active', isEqualTo: true)
          .get();

      if (result.docs.isEmpty) return null;

      final data = result.docs.first.data();
      return UserModel(
        id: null,
        fullName: data['full_name'] ?? '',
        role: data['role'] ?? '',
        phone: data['phone'],
        accessKey: data['access_key'],
        ministryType: data['ministry_type'],
        isActive: data['is_active'] ?? true,
      );
    } catch (e) {
      return null;
    }
  }

  // Admin login — password lang, walang Firestore
  Future<bool> loginAdmin(String password) async {
    return password == 'admin123';
  }

  // Parishioner — walang Firestore, guest access lang
  Future<UserModel> loginParishioner() async {
    return UserModel(id: null, fullName: '', role: 'parishioner');
  }

  // I-save ang session sa SharedPreferences
  Future<void> saveSession(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_role', user.role);
    await prefs.setString('user_name', user.fullName);
    if (user.accessKey != null) {
      await prefs.setString('access_key', user.accessKey!);
    }
    if (user.ministryType != null) {
      await prefs.setString('ministry_type', user.ministryType!);
    }
    if (user.phone != null) {
      await prefs.setString('phone', user.phone!);
    }
  }

  // Kunin ang current session
  Future<UserModel?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userRole = prefs.getString('user_role');
    final userName = prefs.getString('user_name');

    if (userRole == null) return null;

    return UserModel(
      id: null,
      fullName: userName ?? '',
      role: userRole,
      accessKey: prefs.getString('access_key'),
      ministryType: prefs.getString('ministry_type'),
      phone: prefs.getString('phone'),
    );
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

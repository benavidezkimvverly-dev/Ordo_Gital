class UserModel {
  final int? id;
  final String fullName;
  final String? phone;
  final String role;
  final String? accessKey;
  final String? ministryType;
  final bool isActive;

  UserModel({
    this.id,
    required this.fullName,
    this.phone,
    required this.role,
    this.accessKey,
    this.ministryType,
    this.isActive = true,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      fullName: map['full_name'],
      phone: map['phone'],
      role: map['role'],
      accessKey: map['access_key'],
      ministryType: map['ministry_type'],
      isActive: map['is_active'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'full_name': fullName,
      'phone': phone,
      'role': role,
      'access_key': accessKey,
      'ministry_type': ministryType,
      'is_active': isActive ? 1 : 0,
    };
  }
}

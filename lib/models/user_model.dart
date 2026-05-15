enum UserRole { customer, admin }

class UserModel {
  final String uid;
  final String email;
  final String name;
  final String? profileImageUrl;
  final UserRole role;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.profileImageUrl,
    this.role = UserRole.customer,
  });

  bool get isAdmin => role == UserRole.admin;

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'profileImageUrl': profileImageUrl,
      'role': role.name,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      profileImageUrl: map['profileImageUrl'],
      role: UserRole.values.byName(map['role'] ?? 'customer'),
    );
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? name,
    String? profileImageUrl,
    UserRole? role,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      role: role ?? this.role,
    );
  }
}

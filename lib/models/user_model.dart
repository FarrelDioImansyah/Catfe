enum UserRole { customer, admin }

class UserModel {
  final String uid;
  final String email;
  final String name;
  final String username;
  final String? profileImageUrl;
  final String? birthDate; // Format: 'yyyy-MM-dd'
  final UserRole role;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.username,
    this.profileImageUrl,
    this.birthDate,
    this.role = UserRole.customer,
  });

  bool get isAdmin => role == UserRole.admin;

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'username': username,
      'profileImageUrl': profileImageUrl,
      'birthDate': birthDate,
      'role': role.name,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      profileImageUrl: map['profileImageUrl'],
      birthDate: map['birthDate'],
      role: UserRole.values.byName(map['role'] ?? 'customer'),
    );
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? name,
    String? username,
    String? profileImageUrl,
    String? birthDate,
    UserRole? role,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      username: username ?? this.username,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      birthDate: birthDate ?? this.birthDate,
      role: role ?? this.role,
    );
  }
}


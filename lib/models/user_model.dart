/// User model representing a user document in Firestore.
/// Contains all fields from the 'users' collection schema.
class UserModel {
  final String uid;
  final String name;
  final String email;
  final String department;
  final int semester;
  final String profileImageUrl;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.department,
    required this.semester,
    required this.profileImageUrl,
  });

  /// Create a UserModel from a Firestore document map
  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      uid: documentId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      department: map['department'] ?? '',
      semester: map['semester'] ?? 0,
      profileImageUrl: map['profileImageUrl'] ?? '',
    );
  }

  /// Convert UserModel to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'department': department,
      'semester': semester,
      'profileImageUrl': profileImageUrl,
    };
  }

  /// Create a copy of UserModel with some fields replaced
  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? department,
    int? semester,
    String? profileImageUrl,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      department: department ?? this.department,
      semester: semester ?? this.semester,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, email: $email, department: $department, semester: $semester, profileImageUrl: $profileImageUrl)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          name == other.name &&
          email == other.email &&
          department == other.department &&
          semester == other.semester &&
          profileImageUrl == other.profileImageUrl;

  @override
  int get hashCode =>
      uid.hashCode ^
      name.hashCode ^
      email.hashCode ^
      department.hashCode ^
      semester.hashCode ^
      profileImageUrl.hashCode;
}

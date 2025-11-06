import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.department,
    required this.semester,
    required this.profileImageUrl,
  });

  final String uid;
  final String name;
  final String email;
  final String department;
  final int semester;
  final String profileImageUrl;

  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return UserModel(
      uid: doc.id,
      name: (data['name'] ?? '') as String,
      email: (data['email'] ?? '') as String,
      department: (data['department'] ?? '') as String,
      semester: _parseSemester(data['semester']),
      profileImageUrl: (data['profileImageUrl'] ?? '') as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'department': department,
      'semester': semester,
      'profileImageUrl': profileImageUrl,
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? department,
    int? semester,
    String? profileImageUrl,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      department: department ?? this.department,
      semester: semester ?? this.semester,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  static int _parseSemester(dynamic value) {
    if (value == null) {
      return 1;
    }
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value.toString()) ?? 1;
  }
}

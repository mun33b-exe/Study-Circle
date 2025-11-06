import 'package:cloud_firestore/cloud_firestore.dart';

class StudyGroup {
  const StudyGroup({
    required this.id,
    required this.groupName,
    required this.courseName,
    required this.courseCode,
    required this.description,
    required this.maxMembers,
    required this.isPrivate,
    required this.createdByUid,
    required this.members,
  });

  final String id;
  final String groupName;
  final String courseName;
  final String courseCode;
  final String description;
  final int maxMembers;
  final bool isPrivate;
  final String createdByUid;
  final List<String> members;

  factory StudyGroup.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return StudyGroup(
      id: doc.id,
      groupName: (data['groupName'] ?? '') as String,
      courseName: (data['courseName'] ?? '') as String,
      courseCode: (data['courseCode'] ?? '') as String,
      description: (data['description'] ?? '') as String,
      maxMembers: _parseInt(data['maxMembers'], fallback: 10),
      isPrivate: (data['isPrivate'] ?? false) as bool,
      createdByUid: (data['createdBy_uid'] ?? '') as String,
      members: List<String>.from(
        (data['members'] ?? <dynamic>[]).whereType<String>().toList(),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'groupName': groupName,
      'courseName': courseName,
      'courseCode': courseCode,
      'description': description,
      'maxMembers': maxMembers,
      'isPrivate': isPrivate,
      'createdBy_uid': createdByUid,
      'members': members,
    };
  }

  StudyGroup copyWith({
    String? groupName,
    String? courseName,
    String? courseCode,
    String? description,
    int? maxMembers,
    bool? isPrivate,
    String? createdByUid,
    List<String>? members,
  }) {
    return StudyGroup(
      id: id,
      groupName: groupName ?? this.groupName,
      courseName: courseName ?? this.courseName,
      courseCode: courseCode ?? this.courseCode,
      description: description ?? this.description,
      maxMembers: maxMembers ?? this.maxMembers,
      isPrivate: isPrivate ?? this.isPrivate,
      createdByUid: createdByUid ?? this.createdByUid,
      members: members ?? this.members,
    );
  }

  static int _parseInt(dynamic value, {required int fallback}) {
    if (value == null) {
      return fallback;
    }
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value.toString()) ?? fallback;
  }
}

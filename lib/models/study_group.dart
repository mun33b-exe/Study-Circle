import 'package:cloud_firestore/cloud_firestore.dart';

class StudyGroup {
  final String id;
  final String name;
  final String courseName;
  final String courseCode;
  final String description;
  final List<String> topics;
  final int maxMembers;
  final String schedule;
  final String location;
  final bool isPublic;
  final String creatorId;
  final List<String> members;
  final DateTime createdAt;

  StudyGroup({
    required this.id,
    required this.name,
    required this.courseName,
    required this.courseCode,
    required this.description,
    required this.topics,
    required this.maxMembers,
    required this.schedule,
    required this.location,
    required this.isPublic,
    required this.creatorId,
    required this.members,
    required this.createdAt,
  });

  factory StudyGroup.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return StudyGroup(
      id: doc.id,
      name: data['name'] ?? '',
      courseName: data['courseName'] ?? '',
      courseCode: data['courseCode'] ?? '',
      description: data['description'] ?? '',
      topics: List<String>.from(data['topics'] ?? []),
      maxMembers: (data['maxMembers'] ?? 0) is int
          ? data['maxMembers']
          : int.tryParse('${data['maxMembers']}') ?? 0,
      schedule: data['schedule'] ?? '',
      location: data['location'] ?? '',
      isPublic: data['isPublic'] ?? true,
      creatorId: data['creatorId'] ?? '',
      members: List<String>.from(data['members'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'courseName': courseName,
      'courseCode': courseCode,
      'description': description,
      'topics': topics,
      'maxMembers': maxMembers,
      'schedule': schedule,
      'location': location,
      'isPublic': isPublic,
      'creatorId': creatorId,
      'members': members,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

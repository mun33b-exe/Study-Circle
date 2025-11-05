class JoinRequest {
  final String id;
  final String userId;
  final String? displayName;
  final String status;

  JoinRequest({
    required this.id,
    required this.userId,
    this.displayName,
    required this.status,
  });

  factory JoinRequest.fromMap(Map<String, dynamic> map) {
    return JoinRequest(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      displayName: map['displayName'],
      status: map['status'] ?? 'pending',
    );
  }
}

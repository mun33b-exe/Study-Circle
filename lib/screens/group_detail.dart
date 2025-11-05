import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_circle/models/study_group.dart';
import 'package:study_circle/provider/study_group_provider.dart';
import 'package:study_circle/models/join_request.dart';
import 'package:study_circle/services/user_service.dart';

class GroupDetailScreen extends StatelessWidget {
  const GroupDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args == null || args is! StudyGroup) {
      return const Scaffold(body: Center(child: Text('No group provided')));
    }

    final StudyGroup group = args;
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    final isCreator = uid != null && uid == group.creatorId;
    final isMember = uid != null && group.members.contains(uid);

    return Scaffold(
      appBar: AppBar(title: Text(group.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              group.courseName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Join request / approval for private groups
            if (!group.isPublic && !isMember)
              ElevatedButton(
                onPressed: () async {
                  if (user == null) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Not signed in')),
                    );
                    return;
                  }
                  await context.read<StudyGroupProvider>().requestJoin(
                    group.id,
                    user.uid,
                    displayName: user.displayName,
                  );
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Request sent')));
                },
                child: const Text('Request to Join'),
              ),

            if (isCreator) ...[
              const SizedBox(height: 12),
              const Text(
                'Join Requests:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 150,
                child: StreamBuilder<List<JoinRequest>>(
                  stream: context.read<StudyGroupProvider>().streamJoinRequests(
                    group.id,
                  ),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting)
                      return const Center(child: CircularProgressIndicator());
                    final requests = snap.data ?? [];
                    if (requests.isEmpty)
                      return const Center(child: Text('No pending requests'));
                    return ListView.builder(
                      itemCount: requests.length,
                      itemBuilder: (context, idx) {
                        final r = requests[idx];
                        return ListTile(
                          title: Text(r.displayName ?? r.userId),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                onPressed: () async {
                                  await context
                                      .read<StudyGroupProvider>()
                                      .approveRequest(group.id, r.id, r.userId);
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  await context
                                      .read<StudyGroupProvider>()
                                      .rejectRequest(group.id, r.id);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
            Text('Course Code: ${group.courseCode}'),
            const SizedBox(height: 8),
            Text(group.description),
            const SizedBox(height: 8),
            Text('Topics: ${group.topics.join(', ')}'),
            const SizedBox(height: 8),
            Text('Max Members: ${group.maxMembers}'),
            const SizedBox(height: 8),
            Text(
              'Schedule: ${group.schedule.day}/${group.schedule.month}/${group.schedule.year} at ${group.schedule.hour.toString().padLeft(2, '0')}:${group.schedule.minute.toString().padLeft(2, '0')}',
            ),
            const SizedBox(height: 8),
            Text('Location: ${group.location}'),
            const SizedBox(height: 12),
            Text(
              'Members (${group.members.length}):',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: group.members.length,
                itemBuilder: (context, index) {
                  final memberUid = group.members[index];
                  return FutureBuilder<String?>(
                    future: UserService().getDisplayName(memberUid),
                    builder: (context, snap) {
                      final title =
                          snap.connectionState == ConnectionState.done &&
                              (snap.data?.isNotEmpty ?? false)
                          ? snap.data
                          : memberUid;
                      return ListTile(title: Text(title!));
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (!isMember && group.isPublic)
                  ElevatedButton(
                    onPressed: () async {
                      if (user == null) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Not signed in')),
                        );
                        return;
                      }
                      final ok = await context
                          .read<StudyGroupProvider>()
                          .joinGroup(group.id, user.uid);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(ok ? 'Joined' : 'Failed')),
                      );
                    },
                    child: const Text('Join'),
                  ),
                if (isMember)
                  ElevatedButton(
                    onPressed: () async {
                      if (user == null) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Not signed in')),
                        );
                        return;
                      }
                      final ok = await context
                          .read<StudyGroupProvider>()
                          .leaveGroup(group.id, user.uid);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(ok ? 'Left' : 'Failed')),
                      );
                    },
                    child: const Text('Leave'),
                  ),
                const SizedBox(width: 8),
                if (isCreator)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () async {
                      final ok = await context
                          .read<StudyGroupProvider>()
                          .deleteGroup(group.id);
                      if (!context.mounted) return;
                      if (ok) Navigator.of(context).pop();
                    },
                    child: const Text('Delete'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

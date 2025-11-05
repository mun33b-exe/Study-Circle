import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      appBar: AppBar(
        title: Text(group.name),
        elevation: 0,
        actions: [
          if (isCreator)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/groups/create',
                  arguments: group,
                );
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card with Course Info
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    // ignore: deprecated_member_use
                    Theme.of(context).primaryColor.withOpacity(0.7),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Chip(
                        label: Text(
                          group.isPublic ? 'Public' : 'Private',
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor: group.isPublic
                            ? Colors.green.shade100
                            : Colors.orange.shade100,
                      ),
                      const Spacer(),
                      Text(
                        '${group.members.length}/${group.maxMembers}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.people, color: Colors.white, size: 20),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    group.courseName,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    group.courseCode,
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            SizedBox(height: 16.h),

            // Description Card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.description,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        group.description,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),

            // Topics Card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.topic,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Topics',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: group.topics
                            .map(
                              (topic) => Chip(
                                label: Text(topic),
                                backgroundColor: Colors.blue.shade50,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),

            // Schedule & Location Card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Meeting Schedule',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${group.schedule.day}/${group.schedule.month}/${group.schedule.year} at ${group.schedule.hour.toString().padLeft(2, '0')}:${group.schedule.minute.toString().padLeft(2, '0')}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Location',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  group.location,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(height: 12.h),

            // Join Requests Section (for creators only)
            if (isCreator) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.pending_actions,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Join Requests',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        SizedBox(
                          height: 200,
                          child: StreamBuilder<List<JoinRequest>>(
                            stream: context
                                .read<StudyGroupProvider>()
                                .streamJoinRequests(group.id),
                            builder: (context, snap) {
                              if (snap.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              final requests = snap.data ?? [];
                              if (requests.isEmpty) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.inbox,
                                        size: 48,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'No pending requests',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return ListView.separated(
                                itemCount: requests.length,
                                separatorBuilder: (_, __) => const Divider(),
                                itemBuilder: (context, idx) {
                                  final r = requests[idx];
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: CircleAvatar(
                                      child: Text(
                                        (r.displayName ?? r.userId)[0]
                                            .toUpperCase(),
                                      ),
                                    ),
                                    title: Text(
                                      r.displayName ?? r.userId,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    subtitle: const Text('Wants to join'),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                          ),
                                          onPressed: () async {
                                            await context
                                                .read<StudyGroupProvider>()
                                                .approveRequest(
                                                  group.id,
                                                  r.id,
                                                  r.userId,
                                                );
                                            if (!context.mounted) return;
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Request approved',
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                          ),
                                          onPressed: () async {
                                            await context
                                                .read<StudyGroupProvider>()
                                                .rejectRequest(group.id, r.id);
                                            if (!context.mounted) return;
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Request rejected',
                                                ),
                                              ),
                                            );
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
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
            ],

            // Members Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.group,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Members',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${group.members.length}',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      SizedBox(
                        height: 200,
                        child: ListView.separated(
                          itemCount: group.members.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, index) {
                            final memberUid = group.members[index];
                            final isGroupCreator = memberUid == group.creatorId;
                            return FutureBuilder<String>(
                              future: UserService().getDisplayName(memberUid),
                              builder: (context, snap) {
                                final displayName = snap.hasData
                                    ? snap.data!
                                    : 'Loading...';

                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: CircleAvatar(
                                    backgroundColor: isGroupCreator
                                        ? Colors.amber
                                        : null,
                                    child: snap.hasData
                                        ? Text(displayName[0].toUpperCase())
                                        : const CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                  ),
                                  title: Text(displayName),
                                  trailing: isGroupCreator
                                      ? const Chip(
                                          label: Text(
                                            'Creator',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          backgroundColor: Colors.amber,
                                        )
                                      : null,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Action Buttons
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Request to Join (Private groups, non-members)
                  if (!group.isPublic && !isMember && !isCreator)
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Colors.orange,
                      ),
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Request sent')),
                        );
                      },
                      icon: const Icon(Icons.send),
                      label: const Text('Request to Join'),
                    ),

                  // Join Button (Public groups, non-members)
                  if (group.isPublic && !isMember && !isCreator)
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Colors.green,
                      ),
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
                          SnackBar(
                            content: Text(
                              ok ? 'Joined successfully!' : 'Failed to join',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.login),
                      label: const Text('Join Group'),
                    ),

                  // Leave Button (for members)
                  if (isMember && !isCreator)
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Colors.grey,
                      ),
                      onPressed: () async {
                        // Show confirmation dialog
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Leave Group'),
                            content: const Text(
                              'Are you sure you want to leave this group?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Leave'),
                              ),
                            ],
                          ),
                        );
                        if (confirm != true) return;
                        if (!context.mounted) return;

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
                          SnackBar(
                            content: Text(
                              ok ? 'Left group' : 'Failed to leave',
                            ),
                          ),
                        );
                        if (ok) Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Leave Group'),
                    ),

                  // Delete Button (for creator)
                  if (isCreator) ...[
                    SizedBox(height: 8.h),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        side: const BorderSide(color: Colors.red),
                        foregroundColor: Colors.red,
                      ),
                      onPressed: () async {
                        // Show confirmation dialog
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Group'),
                            content: const Text(
                              'Are you sure you want to delete this group? This action cannot be undone.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                        if (confirm != true) return;
                        if (!context.mounted) return;

                        final ok = await context
                            .read<StudyGroupProvider>()
                            .deleteGroup(group.id);
                        if (!context.mounted) return;
                        if (ok) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Group deleted')),
                          );
                          Navigator.of(context).pop();
                        }
                      },
                      icon: const Icon(Icons.delete_forever),
                      label: const Text('Delete Group'),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

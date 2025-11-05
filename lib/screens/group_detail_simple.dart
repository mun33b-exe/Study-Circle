import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_circle/models/study_group.dart';
import 'package:study_circle/provider/study_group_provider.dart';

class GroupDetailScreen extends StatelessWidget {
  final String groupId;
  const GroupDetailScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final groupProvider = context.watch<StudyGroupProvider>();
    final String currentUid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<StudyGroup>(
      stream: groupProvider.getGroupById(groupId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text("Error: ${snapshot.error}")));
        }

        final group = snapshot.data!;
        final bool isMember = group.members.contains(currentUid);

        return Scaffold(
          appBar: AppBar(title: Text(group.name)),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(group.courseName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Text(group.courseCode, style: TextStyle(fontSize: 16, color: Colors.grey.shade700)),
                const SizedBox(height: 16),
                Text(group.description),
                const SizedBox(height: 24),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.people),
                  title: const Text("Members"),
                  subtitle: Text("${group.members.length} / ${group.maxMembers}"),
                ),
                ListTile(
                  leading: Icon(group.isPublic ? Icons.public : Icons.lock),
                  title: Text(group.isPublic ? "Public Group" : "Private Group"),
                ),
                const Spacer(), // Pushes button to the bottom

                // Business Logic UI
                if (groupProvider.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (isMember)
                  const Center(child: Text("You are a member of this group"))
                else if (!group.isPublic)
                  const Center(child: Text("This is a private group"))
                else if (group.members.length >= group.maxMembers)
                  const Center(child: Text("This group is full"))
                else
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final provider = context.read<StudyGroupProvider>();
                        String message = await provider.joinGroupWithValidation(group.id, currentUid);
                        
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                        }
                      },
                      child: const Text("Join Group"),
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}
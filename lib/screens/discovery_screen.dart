import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_circle/models/study_group.dart';
import 'package:study_circle/provider/study_group_provider.dart';
import 'package:study_circle/screens/group_detail.dart';

class DiscoveryScreen extends StatelessWidget {
  const DiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We listen to the provider
    final groupProvider = context.watch<StudyGroupProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Discover Groups"),
      ),
      body: StreamBuilder<List<StudyGroup>>(
        // We use the new 'allGroups' stream
        stream: groupProvider.allGroups,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No groups found. Create one!"));
          }

          final groups = snapshot.data!;

          return ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: ListTile(
                  title: Text(group.name),
                  subtitle: Text(group.courseName),
                  trailing: Text("${group.members.length}/${group.maxMembers}"),
                  onTap: () {
                    // Navigate to the detail screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GroupDetailScreen(groupId: group.id),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

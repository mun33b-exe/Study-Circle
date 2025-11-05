import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_circle/models/study_group.dart';
import 'package:study_circle/provider/study_group_provider.dart';

class MyGroupsScreen extends StatefulWidget {
  const MyGroupsScreen({super.key});

  @override
  State<MyGroupsScreen> createState() => _MyGroupsScreenState();
}

class _MyGroupsScreenState extends State<MyGroupsScreen> {
  bool showPublic = false;
  String search = '';

  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final provider = context.read<StudyGroupProvider>();
    if (uid != null) {
      provider.listenByCreator(uid);
    } else {
      provider.listenAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Groups')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/groups/create'),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search groups',
                    ),
                    onChanged: (v) => setState(() => search = v.trim()),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showPublic = !showPublic;
                      final uid = FirebaseAuth.instance.currentUser?.uid;
                      if (showPublic) {
                        context.read<StudyGroupProvider>().listenAll();
                      } else if (uid != null) {
                        context.read<StudyGroupProvider>().listenByCreator(uid);
                      }
                    });
                  },
                  child: Text(showPublic ? 'Show Mine' : 'Show Public'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<StudyGroupProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading)
                  return const Center(child: CircularProgressIndicator());
                if (provider.errorMessage != null)
                  return Center(child: Text(provider.errorMessage!));
                final List<StudyGroup> groups = provider.groups;
                final filtered = groups.where((g) {
                  final matchesSearch = g.name.toLowerCase().contains(
                    search.toLowerCase(),
                  );
                  final matchesPublic = showPublic ? g.isPublic : true;
                  return matchesSearch && matchesPublic;
                }).toList();
                if (filtered.isEmpty)
                  return const Center(child: Text('No groups found'));
                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final g = filtered[index];
                    return ListTile(
                      title: Text(g.name),
                      subtitle: Text('${g.courseName} • ${g.courseCode}'),
                      trailing: Text('${g.members.length}/${g.maxMembers}'),
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/groups/detail',
                        arguments: g,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

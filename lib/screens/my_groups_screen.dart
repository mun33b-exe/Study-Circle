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
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.errorMessage != null) {
                  final error = provider.errorMessage!;
                  final isIndexError =
                      error.contains('index') ||
                      error.contains('FAILED_PRECONDITION');

                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isIndexError ? Icons.warning : Icons.error,
                            color: Colors.orange,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            isIndexError
                                ? 'Database Index Required'
                                : 'Error Loading Groups',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isIndexError
                                ? 'Click the link in the error message to create the required Firestore index, or toggle to "Show Public" mode.'
                                : error,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 16),
                          if (isIndexError)
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  showPublic = true;
                                  context
                                      .read<StudyGroupProvider>()
                                      .listenAll();
                                });
                              },
                              child: const Text('Switch to Public Groups'),
                            ),
                          TextButton(
                            onPressed: () {
                              provider.errorMessage = null;
                              final uid =
                                  FirebaseAuth.instance.currentUser?.uid;
                              if (showPublic) {
                                provider.listenAll();
                              } else if (uid != null) {
                                provider.listenByCreator(uid);
                              }
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final List<StudyGroup> groups = provider.groups;
                final filtered = groups.where((g) {
                  final matchesSearch = g.name.toLowerCase().contains(
                    search.toLowerCase(),
                  );
                  final matchesPublic = showPublic ? g.isPublic : true;
                  return matchesSearch && matchesPublic;
                }).toList();
                if (filtered.isEmpty) {
                  return const Center(child: Text('No groups found'));
                }
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

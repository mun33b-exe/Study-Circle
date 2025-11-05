import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:study_circle/models/study_group.dart';
import 'package:study_circle/provider/study_group_provider.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _courseName = TextEditingController();
  final _courseCode = TextEditingController();
  final _description = TextEditingController();
  final _topics = TextEditingController();
  final _maxMembers = TextEditingController(text: '3');
  final _schedule = TextEditingController();
  final _location = TextEditingController();
  bool _isPublic = true;

  @override
  void dispose() {
    _name.dispose();
    _courseName.dispose();
    _courseCode.dispose();
    _description.dispose();
    _topics.dispose();
    _maxMembers.dispose();
    _schedule.dispose();
    _location.dispose();
    super.dispose();
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  String? _validateMax(String? v) {
    if (v == null || v.isEmpty) return 'Required';
    final n = int.tryParse(v);
    if (n == null) return 'Enter a number';
    if (n < 3 || n > 10) return 'Must be between 3 and 10';
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Not signed in')));
      return;
    }

    final provider = context.read<StudyGroupProvider>();

    final topicsList = _topics.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    final maxM = int.parse(_maxMembers.text);

    final existing = ModalRoute.of(context)?.settings.arguments;
    final isEdit = existing != null && existing is StudyGroup;

    final StudyGroup group = StudyGroup(
      id: isEdit ? (existing as StudyGroup).id : '',
      name: _name.text.trim(),
      courseName: _courseName.text.trim(),
      courseCode: _courseCode.text.trim(),
      description: _description.text.trim(),
      topics: topicsList,
      maxMembers: maxM,
      schedule: _schedule.text.trim(),
      location: _location.text.trim(),
      isPublic: _isPublic,
      creatorId: isEdit ? existing.creatorId : uid,
      members: isEdit ? existing.members : [uid],
      createdAt: isEdit ? existing.createdAt : DateTime.now(),
    );

    final ok = isEdit
        ? await provider.updateGroup(group)
        : await provider.createGroup(group);
    if (ok) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Group created')));
      Navigator.of(context).pop();
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage ?? 'Failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final existing = ModalRoute.of(context)?.settings.arguments;
    final isEdit = existing != null && existing is StudyGroup;
    if (isEdit) {
      final g = existing as StudyGroup;
      _name.text = g.name;
      _courseName.text = g.courseName;
      _courseCode.text = g.courseCode;
      _description.text = g.description;
      _topics.text = g.topics.join(', ');
      _maxMembers.text = g.maxMembers.toString();
      _schedule.text = g.schedule;
      _location.text = g.location;
      _isPublic = g.isPublic;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Study Group' : 'Create Study Group'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 8.h),
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Group Name'),
                validator: _required,
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _courseName,
                decoration: const InputDecoration(labelText: 'Course Name'),
                validator: _required,
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _courseCode,
                decoration: const InputDecoration(labelText: 'Course Code'),
                validator: _required,
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: _required,
                maxLines: 3,
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _topics,
                decoration: const InputDecoration(
                  labelText: 'Topics (comma separated)',
                ),
                validator: _required,
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _maxMembers,
                decoration: const InputDecoration(
                  labelText: 'Max Members (3-10)',
                ),
                validator: _validateMax,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _schedule,
                decoration: const InputDecoration(
                  labelText: 'Meeting Schedule',
                ),
                validator: _required,
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _location,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: _required,
              ),
              SizedBox(height: 8.h),
              SwitchListTile(
                title: const Text('Public group'),
                value: _isPublic,
                onChanged: (v) => setState(() => _isPublic = v),
              ),
              SizedBox(height: 12.h),
              ElevatedButton(
                onPressed: _submit,
                child: Text(isEdit ? 'Update' : 'Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

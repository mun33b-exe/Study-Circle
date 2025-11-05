import 'package:flutter/material.dart';
import 'package:study_circle/screens/dashboard_screen.dart';
import 'package:study_circle/screens/discovery_screen.dart';
import 'package:study_circle/screens/my_groups_screen.dart';
import 'package:study_circle/screens/profile_screen.dart';

/// Main Navigation Screen with BottomNavigationBar
/// This widget manages navigation between the 4 main tabs of the app
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // List of screens corresponding to each tab
  final List<Widget> _screens = [
    const DashboardScreen(),
    const DiscoveryScreen(),
    const MyGroupsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Discover'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'My Groups'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

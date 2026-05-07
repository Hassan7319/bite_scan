import 'package:flutter/material.dart';
import '../screens/live_lens_screen.dart';
import '../screens/safety_screen.dart';
import '../screens/scrapbook_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const LiveLensScreen(),
    const ScrapbookScreen(),
    const SafetyScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: const Icon(Icons.fullscreen),
                activeIcon: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark ? colorScheme.primaryContainer.withValues(alpha: 0.3) : const Color(0xFFE8F8F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.fullscreen, color: Color(0xFF00B894)),
                ),
                label: 'Live Lens',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.bookmark_added_outlined),
                activeIcon: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark ? colorScheme.primaryContainer.withValues(alpha: 0.3) : const Color(0xFFE8F8F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.bookmark_added, color: Color(0xFF00B894)),
                ),
                label: 'Scrapbook',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.security),
                activeIcon: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark ? colorScheme.primaryContainer.withValues(alpha: 0.3) : const Color(0xFFE8F8F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.security, color: Color(0xFF00B894)),
                ),
                label: 'Safety',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: const Color(0xFF00B894),
            unselectedItemColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            onTap: _onItemTapped,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            backgroundColor: colorScheme.surface,
            elevation: 0,
            selectedFontSize: 12,
            unselectedFontSize: 12,
          ),
        ),
      ),
    );
  }
}

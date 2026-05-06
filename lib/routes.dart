import 'package:flutter/material.dart';
import 'package:bite_scan/screens/live_lens_screen.dart';
import 'package:bite_scan/screens/scrapbook_screen.dart';
import 'package:bite_scan/screens/safety_screen.dart';
import 'package:bite_scan/screens/settings_screen.dart';
import 'package:bite_scan/screens/login_screen.dart';
import 'package:bite_scan/screens/signup_screen.dart';
import 'package:bite_scan/screens/splash_screen.dart';
import 'package:bite_scan/screens/account_details_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String settings = '/settings';
  static const String accountDetails = '/account-details';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      signup: (context) => const SignupScreen(),
      home: (context) => const MainScreen(),
      settings: (context) => const SettingsScreen(),
      accountDetails: (context) => const AccountDetailsScreen(),
    };
  }
}

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
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: theme.bottomNavigationBarTheme.backgroundColor ?? theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
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
                    color: const Color(0xFFE8F8F5).withOpacity(theme.brightness == Brightness.dark ? 0.2 : 1.0),
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
                    color: const Color(0xFFE8F8F5).withOpacity(theme.brightness == Brightness.dark ? 0.2 : 1.0),
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
                    color: const Color(0xFFE8F8F5).withOpacity(theme.brightness == Brightness.dark ? 0.2 : 1.0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.security, color: Color(0xFF00B894)),
                ),
                label: 'Safety',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: const Color(0xFF00B894),
            unselectedItemColor: Colors.grey,
            onTap: _onItemTapped,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            backgroundColor: theme.bottomNavigationBarTheme.backgroundColor ?? theme.cardColor,
            elevation: 0,
            selectedFontSize: 12,
            unselectedFontSize: 12,
          ),
        ),
      ),
    );
  }
}

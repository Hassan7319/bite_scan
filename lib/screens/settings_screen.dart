import 'package:flutter/material.dart';
import 'package:bite_scan/theme_notifier.dart';
import 'package:bite_scan/user_manager.dart';
import 'package:bite_scan/routes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeNotifier.themeModeNotifier,
      builder: (context, currentMode, child) {
        return ValueListenableBuilder<UserData?>(
          valueListenable: UserManager.currentUser,
          builder: (context, userData, child) {
            final theme = Theme.of(context);
            final colorScheme = theme.colorScheme;
            
            return Scaffold(
              backgroundColor: colorScheme.surface,
              appBar: AppBar(
                backgroundColor: colorScheme.surface,
                elevation: 0,
                title: Text(
                  'Settings',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    child: Text(
                      'Appearance',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  _buildThemeOption(
                    context: context,
                    title: 'Light Mode',
                    icon: Icons.light_mode_outlined,
                    value: ThemeMode.light,
                    groupValue: currentMode,
                  ),
                  _buildThemeOption(
                    context: context,
                    title: 'Dark Mode',
                    icon: Icons.dark_mode_outlined,
                    value: ThemeMode.dark,
                    groupValue: currentMode,
                  ),
                  _buildThemeOption(
                    context: context,
                    title: 'System Default',
                    icon: Icons.settings_brightness_outlined,
                    value: ThemeMode.system,
                    groupValue: currentMode,
                  ),
                  Divider(height: 32, color: colorScheme.outlineVariant),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    child: Text(
                      'Account',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  if (userData != null) ...[
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00B894).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.person_outline, color: Color(0xFF00B894)),
                      ),
                      title: Text(userData.name, style: TextStyle(color: colorScheme.onSurface)),
                      subtitle: Text(userData.email, style: TextStyle(color: colorScheme.onSurfaceVariant)),
                      onTap: () => Navigator.pushNamed(context, AppRoutes.accountDetails),
                    ),
                  ] else ...[
                    ListTile(
                      title: Text('No user logged in', style: TextStyle(color: colorScheme.onSurface)),
                    ),
                  ],
                  const SizedBox(height: 8),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.logout, color: Colors.red),
                    ),
                    title: const Text('Logout', style: TextStyle(color: Colors.red)),
                    onTap: () => _showLogoutDialog(context),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildThemeOption({
    required BuildContext context,
    required String title,
    required IconData icon,
    required ThemeMode value,
    required ThemeMode groupValue,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return RadioListTile<ThemeMode>(
      activeColor: const Color(0xFF00B894),
      title: Row(
        children: [
          Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Text(title, style: TextStyle(color: colorScheme.onSurface)),
        ],
      ),
      value: value,
      groupValue: groupValue,
      onChanged: (ThemeMode? newValue) {
        if (newValue != null) {
          ThemeNotifier.setThemeMode(newValue);
        }
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              UserManager.logout();
              Navigator.pop(context); // close dialog
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

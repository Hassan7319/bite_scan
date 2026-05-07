import 'package:flutter/material.dart';
import 'package:bite_scan/user_manager.dart';

class AccountDetailsScreen extends StatelessWidget {
  const AccountDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              'Account Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: userData == null
              ? Center(
                  child: Text(
                    'No user data found',
                    style: TextStyle(color: colorScheme.onSurface),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: colorScheme.primary.withOpacity(0.2),
                        child: Icon(Icons.person, size: 50, color: colorScheme.primary),
                      ),
                      const SizedBox(height: 32),
                      _buildDetailItem(context, 'Full Name', userData.name, Icons.person_outline),
                      _buildDetailItem(context, 'Email Address', userData.email, Icons.email_outlined),
                      _buildDetailItem(context, 'Date of Birth', userData.dob, Icons.calendar_today_outlined),
                      _buildDetailItem(context, 'Gender', userData.gender, Icons.wc_outlined),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildDetailItem(BuildContext context, String label, String value, IconData icon) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surfaceContainerHighest : colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: colorScheme.primary, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12, 
                    color: colorScheme.onSurfaceVariant, 
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

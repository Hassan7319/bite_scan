import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bite_scan/routes.dart';
import 'package:bite_scan/theme_notifier.dart';
import 'package:bite_scan/user_manager.dart';
import 'package:bite_scan/ai_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  bool showOnboarding = true;
  try {
    await Firebase.initializeApp();
    UserManager.isFirebaseReady = true;
    
    // Initialize services
    AIService.initialize();
    await UserManager.initialize();

    final prefs = await SharedPreferences.getInstance();
    showOnboarding = !(prefs.getBool('onboarding_complete') ?? false);
  } catch (e) {
    UserManager.isFirebaseReady = false;
    UserManager.initializationError = e.toString();
    debugPrint('Firebase/Init error: $e');
  }

  runApp(MyApp(initialRoute: showOnboarding ? AppRoutes.onboarding : AppRoutes.splash));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeNotifier.themeModeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          title: 'BiteScan',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00B894)),
            useMaterial3: true,
            fontFamily: 'sans-serif',
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF00B894),
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          themeMode: currentMode,
          initialRoute: initialRoute,
          routes: AppRoutes.getRoutes(),
        );
      },
    );
  }
}

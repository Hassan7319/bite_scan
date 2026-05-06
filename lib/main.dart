import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bite_scan/routes.dart';
import 'package:bite_scan/theme_notifier.dart';
import 'package:bite_scan/user_manager.dart';
import 'package:bite_scan/ai_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp();
    UserManager.isFirebaseReady = true;
    
    // Initialize services
    AIService.initialize();
    await UserManager.initialize();
  } catch (e) {
    UserManager.isFirebaseReady = false;
    UserManager.initializationError = e.toString();
    debugPrint('Firebase initialization failed: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          initialRoute: AppRoutes.splash,
          routes: AppRoutes.getRoutes(),
        );
      },
    );
  }
}

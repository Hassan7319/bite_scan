import 'package:flutter/material.dart';
import 'package:bite_scan/navigation/main_navigation.dart';
import 'package:bite_scan/screens/settings_screen.dart';
import 'package:bite_scan/screens/login_screen.dart';
import 'package:bite_scan/screens/signup_screen.dart';
import 'package:bite_scan/screens/splash_screen.dart';
import 'package:bite_scan/screens/account_details_screen.dart';
import 'package:bite_scan/screens/onboarding_screen.dart';

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String splash = '/splash';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String settings = '/settings';
  static const String accountDetails = '/account-details';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      onboarding: (context) => const OnboardingScreen(),
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      signup: (context) => const SignupScreen(),
      home: (context) => const MainScreen(),
      settings: (context) => const SettingsScreen(),
      accountDetails: (context) => const AccountDetailsScreen(),
    };
  }
}

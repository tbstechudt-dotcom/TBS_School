import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../presentation/screens/splash/splash_screen.dart';
import '../presentation/screens/onboarding/onboarding_screen.dart';
import '../presentation/screens/welcome/welcome_screen.dart';
import '../presentation/screens/auth/sign_in_screen.dart';
import '../presentation/screens/auth/sign_up_screen.dart';
import '../presentation/screens/auth/otp_verification_screen.dart';
import '../presentation/screens/auth/set_password_screen.dart';
import '../presentation/screens/student_selection/student_selection_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/fees/fees_screen.dart';
import '../presentation/screens/fees/fee_details_screen.dart';
import '../presentation/screens/payments/payment_history_screen.dart';
import '../presentation/screens/payments/payment_receipt_screen.dart';
import '../presentation/screens/notifications/notifications_screen.dart';
import '../presentation/screens/profile/profile_screen.dart';
import '../presentation/widgets/common/main_scaffold.dart';
import '../presentation/providers/auth_provider.dart' show parentAuthStateProvider;
import '../presentation/providers/student_provider.dart';

/// Route names
class Routes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const welcome = '/welcome';
  static const signIn = '/sign-in';
  static const signUp = '/sign-up';
  static const otpVerification = '/otp-verification';
  static const setPassword = '/set-password';
  static const studentSelection = '/student-selection';
  static const home = '/home';
  static const fees = '/fees';
  static const feeDetails = '/fees/:feeId';
  static const paymentHistory = '/payment-history';
  static const paymentReceipt = '/payment-history/:paymentId';
  static const notifications = '/notifications';
  static const profile = '/profile';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final parentAuthState = ref.watch(parentAuthStateProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // Allow splash screen to show first
      final isOnSplash = state.matchedLocation == Routes.splash;
      if (isOnSplash) {
        return null; // Let splash screen handle navigation
      }

      // Bypass authentication when using dummy data
      if (useDummyData) {
        return null;
      }

      final isLoggedIn = parentAuthState.valueOrNull?.isAuthenticated ?? false;
      final isOnAuthPage = state.matchedLocation == Routes.signIn ||
          state.matchedLocation == Routes.signUp ||
          state.matchedLocation == Routes.otpVerification ||
          state.matchedLocation == Routes.setPassword;
      final isOnOnboarding = state.matchedLocation == Routes.onboarding;
      final isOnWelcome = state.matchedLocation == Routes.welcome;

      // Allow onboarding and welcome without auth
      if (isOnOnboarding || isOnWelcome) {
        return null;
      }

      // Redirect to welcome if not logged in and not on auth pages
      if (!isLoggedIn && !isOnAuthPage) {
        return Routes.welcome;
      }

      // Redirect to student selection if logged in and on auth pages
      if (isLoggedIn && isOnAuthPage) {
        return Routes.studentSelection;
      }

      return null;
    },
    routes: [
      // Splash Screen
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding Screen
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Welcome Screen
      GoRoute(
        path: Routes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),

      // Auth Routes
      GoRoute(
        path: Routes.signIn,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: Routes.signUp,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: Routes.otpVerification,
        builder: (context, state) {
          final mobile = state.extra as String?;
          return OtpVerificationScreen(mobile: mobile ?? '');
        },
      ),
      GoRoute(
        path: Routes.setPassword,
        builder: (context, state) {
          final mobile = state.extra as String?;
          return SetPasswordScreen(mobile: mobile ?? '');
        },
      ),

      // Student Selection
      GoRoute(
        path: Routes.studentSelection,
        builder: (context, state) => const StudentSelectionScreen(),
      ),

      // Main App with Bottom Navigation (Shell Route)
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: Routes.home,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: Routes.fees,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: FeesScreen(),
            ),
            routes: [
              GoRoute(
                path: ':feeId',
                builder: (context, state) {
                  final feeId = state.pathParameters['feeId']!;
                  return FeeDetailsScreen(feeId: feeId);
                },
              ),
            ],
          ),
          GoRoute(
            path: Routes.paymentHistory,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PaymentHistoryScreen(),
            ),
            routes: [
              GoRoute(
                path: ':paymentId',
                builder: (context, state) {
                  final paymentId = state.pathParameters['paymentId']!;
                  return PaymentReceiptScreen(paymentId: paymentId);
                },
              ),
            ],
          ),
          GoRoute(
            path: Routes.notifications,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: NotificationsScreen(),
            ),
          ),
          GoRoute(
            path: Routes.profile,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.error}'),
      ),
    ),
  );
});

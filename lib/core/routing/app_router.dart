import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/screens/splash_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/form/screens/form_selection_screen.dart';
import '../../features/form/screens/form_step1_screen.dart';
import '../../features/form/screens/form_step2_screen.dart';
import '../../features/form/screens/form_step3_screen.dart';
import '../../features/review/screens/review_screen.dart';
import '../../features/qr/screens/qr_screen.dart';
import '../../features/teller/screens/teller_scan_screen.dart';
import '../../features/teller/screens/teller_verify_screen.dart';
import '../../features/history/screens/history_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String formSelect = '/form-select';
  static const String formStep1 = '/form/step1';
  static const String formStep2 = '/form/step2';
  static const String formStep3 = '/form/step3';
  static const String review = '/review';
  static const String qrCode = '/qr-code';
  static const String qr = qrCode;
  static const String tellerScan = '/teller/scan';
  static const String tellerVerify = '/teller/verify';
  static const String history = '/history';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      pageBuilder: (context, state) => _fadeTransition(
        state,
        const SplashScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.home,
      pageBuilder: (context, state) => _slideTransition(
        state,
        const HomeScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.formSelect,
      pageBuilder: (context, state) => _slideTransition(
        state,
        const FormSelectionScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.formStep1,
      pageBuilder: (context, state) {
        final formType = state.extra as String? ?? 'Cash Deposit';
        return _slideTransition(
            state, FormStep1Screen(formType: formType));
      },
    ),
    GoRoute(
      path: AppRoutes.formStep2,
      pageBuilder: (context, state) => _slideTransition(
        state,
        const FormStep2Screen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.formStep3,
      pageBuilder: (context, state) => _slideTransition(
        state,
        const FormStep3Screen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.review,
      pageBuilder: (context, state) => _slideTransition(
        state,
        const ReviewScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.qrCode,
      pageBuilder: (context, state) => _slideTransition(
        state,
        const QrScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.tellerScan,
      pageBuilder: (context, state) => _slideTransition(
        state,
        const TellerScanScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.tellerVerify,
      pageBuilder: (context, state) {
        final payload = state.extra as Map<String, dynamic>?;
        return _slideTransition(
          state,
          TellerVerifyScreen(payload: payload ?? {}),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.history,
      pageBuilder: (context, state) => _slideTransition(
        state,
        const HistoryScreen(),
      ),
    ),
  ],
);

CustomTransitionPage _fadeTransition(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

CustomTransitionPage _slideTransition(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeInOut));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

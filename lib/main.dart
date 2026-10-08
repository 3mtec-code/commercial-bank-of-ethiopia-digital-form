import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/form/models/transaction_model.dart';
import 'features/form/providers/form_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionModelAdapter());

  runApp(
    ChangeNotifierProvider(
      create: (_) => FormProvider(),
      child: const CbeDigitalFormApp(),
    ),
  );
}

class CbeDigitalFormApp extends StatelessWidget {
  const CbeDigitalFormApp({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<FormProvider>().locale;

    return MaterialApp.router(
      title: 'CBE Digital Form',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,

      // Localizations
      locale: locale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('am'),
      ],
    );
  }
}

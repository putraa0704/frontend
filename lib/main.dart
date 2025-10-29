import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/aduan_provider.dart';
import 'screens/splash/splash_screen.dart';
import 'utils/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AduanProvider()),
      ],
      child: MaterialApp(
        title: 'Lapor Pak',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.getTheme(),
        home: const SplashScreen(),
      ),
    );
  }
}
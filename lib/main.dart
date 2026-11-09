import 'package:flutter/material.dart';

import 'pages/splash_screen_page.dart';

void main() {
  runApp(const SmartKasirApp());
}

class SmartKasirApp extends StatelessWidget {
  const SmartKasirApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Warna dasar aplikasi (diubah di Tantangan 1)
    const Color seedColor = Colors.teal;
    final ColorScheme scheme = ColorScheme.fromSeed(seedColor: seedColor)
        .copyWith(primary: seedColor);

    return MaterialApp(
      title: 'SmartKasir',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 2,
          backgroundColor: scheme.primary,
          foregroundColor: Colors.white,
        ),
      ),
      // Membatasi lebar agar tampil seperti layar HP di Chrome
      builder: (context, child) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: child,
        ),
      ),
      home: const SplashScreenPage(),
    );
  }
}

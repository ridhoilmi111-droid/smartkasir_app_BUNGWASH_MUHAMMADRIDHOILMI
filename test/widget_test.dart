import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartkasir_app/main.dart';
import 'package:smartkasir_app/pages/dashboard_page.dart';
import 'package:smartkasir_app/pages/main_navigation_page.dart';

void main() {
  testWidgets('SmartKasirApp renders SplashScreenPage', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartKasirApp());

    // Verify splash screen content
    expect(find.text('SmartKasir'), findsWidgets);
    expect(find.text('Aplikasi Kasir Point of Sale Digital'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Replace widget to cleanly invoke dispose() and cancel splash timer
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('MainNavigationPage displays navigation bar and default page',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MainNavigationPage(),
      ),
    );

    // Verify bottom navigation items
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Kasir'), findsOneWidget);
    expect(find.text('Riwayat'), findsOneWidget);
    expect(find.text('Toko'), findsOneWidget);

    // Verify initial page is DashboardPage
    expect(find.text('Total Penjualan Hari Ini'), findsOneWidget);
  });

  testWidgets('DashboardPage renders category chips and title',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: DashboardPage(),
      ),
    );

    // Verify dashboard elements
    expect(find.text('SmartKasir'), findsWidgets);
    expect(find.text('Total Penjualan Hari Ini'), findsOneWidget);
    expect(find.text('Semua'), findsOneWidget);
    expect(find.text('Makanan'), findsOneWidget);
    expect(find.text('Minuman'), findsOneWidget);
    expect(find.text('Snack'), findsOneWidget);
  });
}

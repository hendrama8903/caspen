import 'package:caspen/models/database.dart';
import 'package:caspen/pages/category_provider.dart';
import 'package:caspen/pages/main_page.dart';
import 'package:caspen/pages/transaction_provider.dart';
// import provider kamu
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    Provider<AppDb>(
      create: (_) => AppDb(), // Shared DB instance
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create:
                (context) =>
                    CategoryProvider(Provider.of<AppDb>(context, listen: false))
                      ..loadCategories(),
          ),
          ChangeNotifierProvider(
            create:
                (context) => TransactionProvider(
                  Provider.of<AppDb>(context, listen: false),
                )..loadTransactions(), // opsional kalau ada
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'CasPen', home: const MainPage());
  }
}

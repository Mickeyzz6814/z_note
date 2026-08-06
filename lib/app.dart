import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:z_note/core/providers/theme_provider.dart';
import 'package:z_note/core/routes/app_routes.dart';
import 'package:z_note/main.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return MaterialApp(
      navigatorKey: navigatorKey,
      initialRoute: '/home',
      routes: appRoutes,
      title: 'Z Note',
      //home: Home(),
      theme: themeProvider.currentTheme,
    );
  }
}

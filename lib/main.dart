import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:z_note/pages/update_page.dart';
import 'package:z_note/start.dart';
import 'package:z_note/home.dart';
//import 'package:z_note/main_pages/home_page.dart';
import 'package:z_note/models/note_model.dart';
import 'package:z_note/models/settings_model.dart';
import 'package:z_note/pages/about_page.dart';
import 'package:z_note/pages/note_edit_page.dart';
import 'package:z_note/pages/note_show_page.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
bool hasShow = false;
int localBuildId = 4;

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NoteModelAdapter());
  Hive.registerAdapter(SettingsModelAdapter());
  await Hive.openBox('note_box');
  await Hive.openBox<SettingsModel>('settings_box');
  await startt();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      navigatorObservers: [routeObserver],
      initialRoute: '/home',
      routes: {
        '/about': (context) => AboutPage(),
        '/edit': (context) => NoteEditPage(),
        '/show': (context) => NoteShowPage(),
        '/home': (context) => Home(),
        '/update': (context) => updatePage(),
      },
      title: 'Z Note',
      //home: Home(),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 201, 235, 234),
        ),
      ),
    );
  }
}

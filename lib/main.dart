import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:z_note/app.dart';
import 'package:z_note/data/repositories/settings_repository.dart';
import 'package:z_note/features/note/providers/note_provider.dart';
import 'package:z_note/data/models/note_model.dart';
import 'package:z_note/data/models/settings_model.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NoteModelAdapter());
  Hive.registerAdapter(SettingsModelAdapter());
  await Hive.openBox('note_box');
  await Hive.openBox<SettingsModel>('settings_box');
  await SettingsRepository.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NoteProvider()..loadNotes()),
      ],
      child: App(),
    ),
  );
}

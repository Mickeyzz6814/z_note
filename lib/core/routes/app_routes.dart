import 'package:flutter/cupertino.dart';
import 'package:z_note/features/about/presentation/about_page.dart';
import 'package:z_note/features/home/home_shell.dart';
import 'package:z_note/features/note/presentation/note_edit_page.dart';
import 'package:z_note/features/note/presentation/note_show_page.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/about': (context) => AboutPage(),
  '/edit': (context) => NoteEditPage(),
  '/show': (context) => NoteShowPage(),
  '/home': (context) => Home(),
};

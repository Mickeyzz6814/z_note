//import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:z_note/models/settings_model.dart';

Future<void> startt() async {
  final settingsBox = Hive.box<SettingsModel>('settings_box');
  SettingsModel? settings = settingsBox.get(0);
  //dynamic s = settings.autoCheckUpdate;
  if (settings == null) {
    final ss = SettingsModel(autoCheckUpdate: true);
    await settingsBox.put(0, ss);
    return;
  } else {
    return;
  }
}

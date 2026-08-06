import 'package:flutter/material.dart';
import 'package:z_note/core/theme/app_theme.dart';
import 'package:z_note/data/repositories/settings_repository.dart';

class ThemeProvider extends ChangeNotifier {
  bool _darkMode = false;
  bool get darkMode => _darkMode;
  //static Box settingsBox = Hive.box('settings_box');

  ThemeData get currentTheme {
    if (darkMode == true) {
      return AppTheme.darkMode();
    } else {
      return AppTheme.lightMode();
    }
  }

  //bool getThemeInformatinon() {
  //  SettingsModel? settings = settingsBox.get(0);
  //  _darkMode = settings!.darkMode;
  //  return _darkMode;
  //}

  //Future<void> initTheme() async {
  //  _darkMode = await SettingsRepository.getThemeInformation();
  //  notifyListeners();
  //}

  Future<void> toggleTheme() async {
    _darkMode = !_darkMode;
    await SettingsRepository.saveThemeInformation(themeInformation: _darkMode);
    notifyListeners();
  }

  void setInitState(bool value) {
    _darkMode = value;
  }
}

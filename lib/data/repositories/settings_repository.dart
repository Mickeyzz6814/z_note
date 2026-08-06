import 'package:hive/hive.dart';
import 'package:z_note/data/models/settings_model.dart';

class SettingsRepository {
  static Box<SettingsModel> get settingsBox =>
      Hive.box<SettingsModel>('settings_box');

  static Future<void> init() async {
    SettingsModel? settings = settingsBox.get(0);
    //dynamic s = settings.autoCheckUpdate;
    if (settings == null) {
      final ss = SettingsModel(autoCheckUpdate: true, darkMode: false);
      await settingsBox.put(0, ss);
      print('成功初始化');
      return;
    } else {
      print('不需要初始化');
      return;
    }
  }

  static Future<bool> getUpdateInformation() async {
    SettingsModel? settings = settingsBox.get(0);
    bool updateSettings = settings!.autoCheckUpdate;
    if (updateSettings == true || updateSettings == false) {
      print('传回数据库真实数据');
      return updateSettings;
    } else {
      print('传回default数据,初始化操作异常');
      return true;
    }
  }

  static Future<void> saveUpdateInformation({
    required bool updateInformation,
  }) async {
    SettingsModel? settings = settingsBox.get(0);
    settings!.autoCheckUpdate = updateInformation;
    await settings.save();
    print('保存了数据');
    return;
  }

  static Future<bool> getThemeInformation() async {
    SettingsModel? settings = settingsBox.get(0);
    bool themeSettings = settings!.darkMode;
    if (themeSettings == true || themeSettings == false) {
      print('传回数据库真实数据');
      return themeSettings;
    } else {
      print('传回default数据,初始化操作异常');
      return false;
    }
  }

  static Future<void> saveThemeInformation({
    required bool themeInformation,
  }) async {
    SettingsModel? settings = settingsBox.get(0);
    settings!.darkMode = themeInformation;
    await settings.save();
    print('保存了数据');

    return;
  }
}

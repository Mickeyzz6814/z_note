import 'package:hive/hive.dart';
import 'package:z_note/data/models/settings_model.dart';

class SettingsRepository {
  static Box<SettingsModel> get settingsBox =>
      Hive.box<SettingsModel>('settings_box');

  static Future<void> init() async {
    SettingsModel? updateSettings = settingsBox.get(0);
    //dynamic s = settings.autoCheckUpdate;
    if (updateSettings == null) {
      final ss = SettingsModel(autoCheckUpdate: true);
      await settingsBox.put(0, ss);
      print('成功初始化');
      return;
    } else {
      print('不需要初始化');
      return;
    }
  }

  static Future<bool> getUpdateInformation() async {
    SettingsModel? updateSettings = settingsBox.get(0);
    bool settings = updateSettings!.autoCheckUpdate;
    if (settings == true || settings == false) {
      print('传回数据库真实数据');
      return settings;
    } else {
      print('传回default数据,初始化操作异常');
      return true;
    }
  }

  static Future<void> saveUpdateInformation({
    required bool updateInformation,
  }) async {
    SettingsModel? updateSettings = settingsBox.get(0);
    updateSettings!.autoCheckUpdate = updateInformation;
    await updateSettings.save();
    print('保存了数据');
    return;
  }
}

import 'package:hive/hive.dart';

part 'settings_model.g.dart';

@HiveType(typeId: 1)
class SettingsModel extends HiveObject {
  @HiveField(0)
  bool autoCheckUpdate;

  @HiveField(1)
  bool darkMode;

  SettingsModel({required this.autoCheckUpdate, required this.darkMode});
}

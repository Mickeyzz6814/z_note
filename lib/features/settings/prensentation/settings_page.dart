import 'package:flutter/material.dart';
import 'package:z_note/data/models/settings_model.dart';
import 'package:z_note/data/repositories/settings_repository.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _autoCheckUpdateSwitchValue = true;
  SettingsModel? settings;
  bool? value;

  @override
  void initState() {
    super.initState();
    _loadData();
    //final settingsBox = Hive.box<SettingsModel>('settings_box');
    //settings = settingsBox.get(0);
    //if (settings == null) {
    //  final ss = SettingsModel(autoCheckUpdate: true);
    //  settingsBox.put(0, ss);
    // settings = SettingsModel(autoCheckUpdate: true);
    //}
  }

  Future<void> _loadData() async {
    value = await SettingsRepository.getUpdateInformation();
    setState(() {});
    _autoCheckUpdateSwitchValue = value!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false, // appbar标题居左
        automaticallyImplyLeading: false, // appbar去除home默认返回按键,
        title: Text('设置', style: TextStyle(fontSize: 27)),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 20),
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Text('更多', style: TextStyle(fontSize: 13)),
            ),
            Card(
              clipBehavior: Clip.antiAlias, // 裁切多余阴影
              elevation: 0,
              child: ListTile(
                leading: Icon(Icons.update),
                title: Text('自动检查更新'),
                trailing: Switch(
                  value: _autoCheckUpdateSwitchValue,
                  onChanged: (bool newValue) async {
                    _autoCheckUpdateSwitchValue = newValue;
                    await SettingsRepository.saveUpdateInformation(
                      updateInformation: _autoCheckUpdateSwitchValue,
                    );
                    print('保存函数调用完成$_autoCheckUpdateSwitchValue');
                    setState(() {});
                    //print('${settings!.autoCheckUpdate}');
                  },
                ),
                //onTap: () {
                //  Navigator.pushNamed(context, '/about');
                //},
              ),
            ),
            Card(
              clipBehavior: Clip.antiAlias, // 裁切多余阴影
              elevation: 0,
              child: ListTile(
                leading: Icon(Icons.info),
                title: Text('关于'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pushNamed(context, '/about');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

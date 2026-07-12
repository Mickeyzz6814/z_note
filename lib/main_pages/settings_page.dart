import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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

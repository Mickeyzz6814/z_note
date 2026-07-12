import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String appVersion = 'Loading...';
  String deviceModel = "Loading...";
  String androidVersion = "Loading...";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadAppInfo(); //调用读取信息
  }

  Future<void> _loadAppInfo() async {
    // 读取应用版本
    PackageInfo pkg = await PackageInfo.fromPlatform();
    // 读取安卓设备系统信息
    DeviceInfoPlugin devicePlugin = DeviceInfoPlugin();
    AndroidDeviceInfo android = await devicePlugin.androidInfo;

    setState(() {
      appVersion = "${pkg.version}(${pkg.buildNumber})";
      deviceModel = "${android.manufacturer} ${android.model}";
      androidVersion =
          "Android ${android.version.release} SDK${android.version.sdkInt}";
    });
  }

  // 传入网址字符串，跳转外部浏览器
  Future<void> openWebLink(String link, BuildContext context) async {
    final Uri url = Uri.parse(link);
    // 判断设备能否打开链接
    if (!await canLaunchUrl(url)) {
      // 失败弹窗提示
      if (context.mounted) {
        await showFailDialog(context, '未找到可用应用打开链接');
      }
      return;
    }
    // externalApplication：调用手机默认浏览器打开
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Future<void> openEmail({
    required String toMail,
    String? subject,
    String? body,
    required BuildContext context,
  }) async {
    // 拼接 mailto 链接
    String mailUrl = "mailto:$toMail";
    List<String> params = [];
    if (subject != null) params.add("subject=${Uri.encodeComponent(subject)}");
    if (body != null) params.add("body=${Uri.encodeComponent(body)}");
    if (params.isNotEmpty) {
      mailUrl += "?${params.join("&")}";
    }

    final Uri uri = Uri.parse(mailUrl);
    if (!await canLaunchUrl(uri)) {
      if (context.mounted) {
        await showFailDialog(context, '未找到可用应用打开链接');
      }
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> showFailDialog(BuildContext context, String msg) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
            ),
            SizedBox(width: 8),
            Text("打开失败"),
          ],
        ),
        content: Text(msg),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text("确定")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('关于', style: TextStyle(fontSize: 20)),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              //height: 150,
              child: Card(
                elevation: 0,
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Image.asset(
                      'lib/assets/images/icon/icon.png',
                      height: 100,
                      width: 100,
                    ),
                    SizedBox(height: 5),
                    Text('Z Note', style: TextStyle(fontSize: 18)),
                    //SizedBox(height: 3),
                    Text(
                      '${appVersion} | ${deviceModel} | ${androidVersion}',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 216, 216, 216),
                        fontSize: 10,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            Container(
              child: Card(
                clipBehavior: Clip.antiAlias, // 裁切多余阴影
                elevation: 0,
                child: Column(
                  children: [
                    ListTile(
                      leading: FaIcon(FontAwesomeIcons.github, size: 20),
                      title: Text('查看源码'),
                      subtitle: Text(
                        '在Github上查看本项目的源码',
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () async {
                        await openWebLink(
                          'https://github.com/Mickeyzz6814/z_note/',
                          context,
                        ); // 暂时填充
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.bug_report),
                      title: Text('反馈问题'),
                      subtitle: Text(
                        '通过邮箱向我们反馈你遇到的问题',
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () async {
                        await openEmail(
                          toMail: 'mickeyzz6814@gmail.com',
                          subject: 'Z Note 使用反馈',
                          context: context,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 50,
              child: Card(
                elevation: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(FontAwesomeIcons.flutter),
                    SizedBox(width: 15),
                    FaIcon(FontAwesomeIcons.dartLang),
                    SizedBox(width: 15),
                    FaIcon(FontAwesomeIcons.github),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

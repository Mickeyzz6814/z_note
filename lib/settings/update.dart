import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:z_note/main.dart';
import 'package:z_note/models/settings_model.dart';
import 'package:http/http.dart' as http;

String checkUri =
    'https://gh-proxy.org/https://raw.githubusercontent.com/Mickeyzz6814/z_note/refs/heads/main/update.json';

class CheckUpdate {
  // 传入网址字符串，跳转外部浏览器
  static Future<void> openWebLink(String link, BuildContext context) async {
    final Uri url = Uri.parse(link);
    // 判断设备能否打开链接
    if (!await canLaunchUrl(url)) {
      // 失败弹窗提示
      if (context.mounted) {
        await showFailDialog(context, '找不到可以打开该链接的应用哦(>_<)');
      }
      return;
    }
    // externalApplication：调用手机默认浏览器打开
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  static Future<void> showFailDialog(BuildContext context, String msg) {
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
            Text("打开失败(T_T)"),
          ],
        ),
        content: Text(msg),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text("确定")),
        ],
      ),
    );
  }

  static Future<void> autoCheckUpdate() async {
    final settingsBox = Hive.box<SettingsModel>('settings_box');
    SettingsModel? settings = settingsBox.get(0)!;
    bool isOn = settings.autoCheckUpdate;
    if (isOn) {
      if (hasShow == false) {
        //print('自动更新调用网络操作函数');
        await _doNetworkCheck();
      }
    }
  }

  static Future<void> checkUpdate() async {
    //print('手动更新调用网络操作函数');
    await _doNetworkCheck();
  }

  static Future<void> _doNetworkCheck() async {
    hasShow = true;
    try {
      final res = await http.get(Uri.parse(checkUri));
      //print('获取更新配置');
      if (res.statusCode != 200) return;
      //print('成功拿到更新配置');
      final Map<String, dynamic> remoteJson = jsonDecode(res.body);
      int remoteBuildId = remoteJson['buildId'];
      String remoteVersionName = remoteJson['versionName'];
      String remoteDownloadUrl = remoteJson['downloadUrl'];
      String remoteUpdateLog = remoteJson['updateLog'];
      if (remoteBuildId > localBuildId) {
        //print('需要更新');
        if (navigatorKey.currentState == null) return;
        await showDialog(
          context: navigatorKey.currentContext!,
          useRootNavigator: true,
          builder: (ctx) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text('哇，有新版本可以更新咯(^ω^)! v$remoteVersionName'),
              content: Container(
                height: 130,
                child: SingleChildScrollView(child: Text(remoteUpdateLog)),
              ),
              actionsPadding: EdgeInsets.only(right: 12, bottom: 8),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text('稍后'),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    await openWebLink(remoteDownloadUrl, ctx);
                  },
                  child: Text('更新'),
                ),
              ],
            );
          },
        );
      } else {
        if (remoteBuildId == localBuildId) {
          //print('不需要更新');
          await showDialog(
            context: navigatorKey.currentContext!,
            useRootNavigator: true,
            builder: (ctx) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Text('最新版本'),
                content: Text('当前已经是最新版本(≧∇≦)，暂时不需要更新哒~'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text('确定'),
                  ),
                ],
              );
            },
          );
        } else {
          return;
        }
      }
    } catch (e) {
      //print('${e.toString()}');
      await showDialog(
        context: navigatorKey.currentContext!,
        useRootNavigator: true,
        builder: ((context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text('哎呀，出错了(>_<)!'),
            content: Container(
              child: Column(
                children: [
                  Container(child: Text('可以通过 GitHub/邮箱联系作者，尽量完整说明问题呀!')),
                  SizedBox(height: 8),
                  Container(
                    height: 280,
                    child: SingleChildScrollView(
                      child: Text('${e.toString()}'),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('确定'),
              ),
            ],
          );
        }),
      );
    }
  }
}

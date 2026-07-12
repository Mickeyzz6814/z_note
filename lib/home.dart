import 'package:flutter/material.dart';
import 'package:z_note/main_pages/settings_page.dart';
import 'package:z_note/main_pages/home_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int pageIndex = 0;
  final List<Widget> bottomPage = [HomePage(), SettingsPage()];

  void tell(int idx) {
    pageIndex = idx;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bottomPage[pageIndex],
      bottomNavigationBar: BottomNavigator(tell: tell),
    );
  }
}

class BottomNavigator extends StatefulWidget {
  final void Function(int) tell;
  const BottomNavigator({super.key, required this.tell});

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: (int newIndex) {
        pageIndex = newIndex;
        widget.tell(newIndex);
        setState(() {});
      },
      selectedIndex: pageIndex,
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          label: '主页',
          selectedIcon: Icon(Icons.home),
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: '设置',
        ),
      ],
    );
  }
}

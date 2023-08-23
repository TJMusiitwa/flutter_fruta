import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_fruta/macos_main.dart';
import 'package:flutter_fruta/screens/favourites_screen.dart';
import 'package:flutter_fruta/screens/menu_screen.dart';
import 'package:flutter_fruta/screens/recipes_screen.dart';
import 'package:flutter_fruta/screens/rewards_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart'
    show MaterialWithModalsPageRoute;

Future<void> _configureMacosWindowUtils() async {
  const config = MacosWindowUtilsConfig(
    toolbarStyle: NSWindowToolbarStyle.unified,
  );
  await config.apply();
}

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox('frutaFavourites');
  if (Platform.isMacOS) {
    await _configureMacosWindowUtils();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Platform.isMacOS) {
      return MacosApp(
        title: 'Flutter Fruta',
        theme: MacosThemeData(
          primaryColor: const Color.fromRGBO(229, 150, 181, 1),
          typography: MacosTypography.darkOpaque(),
        ),
        darkTheme: MacosThemeData.dark().copyWith(
          primaryColor: const Color.fromRGBO(229, 150, 181, 1),
          typography: MacosTypography.lightOpaque(),
        ),
        themeMode: ThemeMode.system,
        home: const MacOSMain(),
      );
    }
    return CupertinoApp(
      title: 'Flutter Fruta',
      theme: const CupertinoThemeData(
          primaryColor: Color.fromRGBO(229, 150, 181, 1),
          textTheme: CupertinoTextThemeData()),
      onGenerateRoute: (settings) => MaterialWithModalsPageRoute(
        builder: (context) => CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.list_bullet), label: 'Menu'),
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.heart_fill), label: 'Favourites'),
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.checkmark_seal_fill),
                    label: 'Rewards'),
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.book_fill), label: 'Recipes'),
              ],
            ),
            tabBuilder: (context, index) {
              late CupertinoTabView returnValue;
              switch (index) {
                case 0:
                  returnValue = CupertinoTabView(
                    builder: (context) =>
                        CupertinoPageScaffold(child: MenuScreen()),
                  );
                  break;
                case 1:
                  returnValue = CupertinoTabView(
                    builder: (context) =>
                        CupertinoPageScaffold(child: FavouritesScreen()),
                  );
                  break;
                case 2:
                  returnValue = CupertinoTabView(
                    builder: (context) =>
                        CupertinoPageScaffold(child: RewardsScreen()),
                  );
                  break;
                case 3:
                  returnValue = CupertinoTabView(
                    builder: (context) =>
                        CupertinoPageScaffold(child: RecipesScreen()),
                  );
                  break;
              }
              return returnValue;
            }),
      ),
    );
  }
}

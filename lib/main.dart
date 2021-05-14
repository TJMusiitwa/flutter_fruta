import 'package:flutter/cupertino.dart';
import 'package:flutter_fruta/screens/favourites_screen.dart';
import 'package:flutter_fruta/screens/menu_screen.dart';
import 'package:flutter_fruta/screens/recipes_screen.dart';
import 'package:flutter_fruta/screens/rewards_screen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox('frutaFavourites');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Flutter Fruta',
      theme: CupertinoThemeData(
          primaryColor: Color.fromRGBO(229, 150, 181, 1),
          textTheme: CupertinoTextThemeData()),
      home: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            items: [
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
    );
  }
}

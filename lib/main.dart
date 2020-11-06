import 'package:flutter/cupertino.dart';
import 'package:flutter_fruta/screens/favourites_screen.dart';
import 'package:flutter_fruta/screens/menu_screen.dart';
import 'package:flutter_fruta/screens/recipes_screen.dart';
import 'package:flutter_fruta/screens/rewards_screen.dart';

void main() => runApp(MyApp());

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
                  icon: Icon(CupertinoIcons.book_fill), label: 'Recipes'),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.checkmark_seal_fill),
                  label: 'Rewards'),
            ],
          ),
          tabBuilder: (context, index) {
            CupertinoTabView returnValue;
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
                      CupertinoPageScaffold(child: RecipesScreen()),
                );
                break;
              case 3:
                returnValue = CupertinoTabView(
                  builder: (context) =>
                      CupertinoPageScaffold(child: RewardsScreen()),
                );
                break;
            }
            return returnValue;
          }),
    );
  }
}

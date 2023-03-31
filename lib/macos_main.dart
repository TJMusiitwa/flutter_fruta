import 'package:flutter/cupertino.dart';
import 'package:flutter_fruta/macos_screens/favourites_screen.dart';
import 'package:flutter_fruta/macos_screens/menu_screen.dart';
import 'package:flutter_fruta/macos_screens/recipes_screen.dart';
import 'package:flutter_fruta/macos_screens/rewards_screen.dart';
import 'package:macos_ui/macos_ui.dart';

class MacOSMain extends StatefulWidget {
  const MacOSMain({Key? key}) : super(key: key);

  @override
  State<MacOSMain> createState() => _MacOSMainState();
}

class _MacOSMainState extends State<MacOSMain> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MacosWindow(
      sidebar: Sidebar(
        builder: (context, controller) => SidebarItems(
            currentIndex: pageIndex,
            onChanged: (i) => setState(() => pageIndex = i),
            scrollController: controller,
            items: const [
              SidebarItem(
                leading: Icon(CupertinoIcons.list_bullet),
                label: Text('Menu'),
              ),
              SidebarItem(
                leading: Icon(CupertinoIcons.heart),
                label: Text('Favorites'),
              ),
              SidebarItem(
                leading: Icon(CupertinoIcons.book_fill),
                label: Text('Recipes'),
              ),
              SidebarItem(
                leading: Icon(CupertinoIcons.checkmark_seal),
                label: Text('Rewards'),
              ),
            ]),
        minWidth: 200,
        isResizable: false,
        bottom: const Padding(
            padding: EdgeInsets.all(16.0),
            child: MacosListTile(
              leading: MacosIcon(CupertinoIcons.profile_circled),
              title: Text('Fruta User'),
              subtitle: Text('user@fruta.com'),
            )),
      ),
      child: IndexedStack(
        index: pageIndex,
        children: const [
          MacosMenuScreen(),
          MacosFavouritesScreen(),
          MacosRecipesScreen(),
          MacosRewardsScreen()
        ],
      ),
    );
  }
}

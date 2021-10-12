import 'package:flutter/cupertino.dart';
import 'package:flutter_fruta/screens/favourites_screen.dart';
import 'package:flutter_fruta/screens/menu_screen.dart';
import 'package:flutter_fruta/screens/recipes_screen.dart';
import 'package:flutter_fruta/screens/rewards_screen.dart';
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
      child: IndexedStack(
        index: pageIndex,
        children: [MenuScreen(), FavouritesScreen(), RecipesScreen()],
      ),
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
            ]),
        minWidth: 200,
        isResizable: false,
        bottom: GestureDetector(
          onTap: () => Navigator.push(
              context, CupertinoPageRoute(builder: (_) => RewardsScreen())),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Icon(CupertinoIcons.checkmark_seal),
                SizedBox(width: 8.0),
                Text('Rewards'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

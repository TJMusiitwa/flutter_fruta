import 'package:flutter/cupertino.dart';

import 'package:flutter_fruta/model/smoothie_model.dart';
import 'package:flutter_fruta/widgets/drink_view_widget.dart';
import 'package:flutter_fruta/widgets/menu_list_tile.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        CupertinoSliverNavigationBar(
          largeTitle: Text('Menu'),
        ),
        SliverSafeArea(
          sliver: SliverFillRemaining(
              child: FutureBuilder(
            future: DefaultAssetBundle.of(context)
                .loadString("assets/smoothie_data.json"),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              final smoothie = smoothieFromJson(snapshot.data.toString());
              return CupertinoScrollbar(
                child: ListView.separated(
                  itemCount: smoothie.length,
                  itemBuilder: (BuildContext context, int index) {
                    var smoothieItem = smoothie[index];
                    return MenuListTile(
                      drinkName: smoothieItem.smoothieName,
                      imagePath: smoothieItem.imagePath,
                      drinkCalories: smoothieItem.calories.toString(),
                      onTap: () => Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => DrinkViewWidget(
                                imagePath: smoothieItem.imagePath,
                                drinkDesc: smoothieItem.description,
                                drinkName: smoothieItem.smoothieName)),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      Padding(
                    padding: const EdgeInsets.only(left: 120.0),
                    child: Container(
                      color: CupertinoColors.separator.darkHighContrastColor,
                      height: 1,
                    ),
                  ),
                ),
              );
            },
          )),
        ),
      ],
    );
  }
}

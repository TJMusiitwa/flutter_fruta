import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_fruta/widgets/favourites_bottom_widget.dart';
import 'package:flutter_fruta/widgets/menu_list_tile.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class FavouritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        CupertinoSliverNavigationBar(
          largeTitle: Text('Favourites'),
        ),
        SliverSafeArea(
          sliver: SliverFillRemaining(
            child: ValueListenableBuilder(
              valueListenable: Hive.box('frutaFavourites').listenable(),
              builder: (context, box, child) {
                if (box.isEmpty) {
                  return Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Add some smoothies to your favourites',
                      style: CupertinoTheme.of(context).textTheme.textStyle,
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (BuildContext context, int index) {
                    var favItem = box.values.toList();
                    return MenuListTile(
                        drinkName: favItem[index]['name'],
                        imagePath: favItem[index]['image'],
                        drinkCalories: favItem[index]['calories'].toString(),
                        onTap: () => showCupertinoModalBottomSheet(
                            context: context,
                            builder: (context, controller) {
                              return Container(
                                height: MediaQuery.of(context).size.height / 2,
                                child: FavouritesBottomWidget(
                                  name: favItem[index]['name'],
                                  imagePath: favItem[index]['image'],
                                  desc: favItem[index]['desc'],
                                  calories:
                                      favItem[index]['calories'].toString(),
                                ),
                              );
                            }));
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

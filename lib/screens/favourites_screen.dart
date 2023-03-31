import 'package:flutter/cupertino.dart';
import 'package:flutter_fruta/widgets/favourites_bottom_widget.dart';
import 'package:flutter_fruta/widgets/menu_list_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class FavouritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, _) => [
        const CupertinoSliverNavigationBar(
          largeTitle: Text('Favourites'),
        ),
      ],
      body: ValueListenableBuilder(
        valueListenable: Hive.box('frutaFavourites').listenable(),
        builder: (context, dynamic box, child) {
          if (box.isEmpty) {
            return Align(
              alignment: Alignment.center,
              child: Text(
                '❤️ some smoothies to see them appear here',
                style: CupertinoTheme.of(context).textTheme.textStyle,
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: box.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              var favItem = box.values.toList();
              return MenuListTile(
                  drinkName: favItem[index]['name'],
                  imagePath: favItem[index]['image'],
                  drinkCalories: favItem[index]['calories'].toString(),
                  ingredients: favItem[index]['ingredients'].toString(),
                  onTap: () => showCupertinoModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 2,
                          child: FavouritesBottomWidget(
                            name: favItem[index]['name'],
                            imagePath: favItem[index]['image'],
                            desc: favItem[index]['desc'],
                            calories: favItem[index]['calories'].toString(),
                            ing: favItem[index]['ingredients'],
                          ),
                        );
                      }));
            },
          );
        },
      ),
    );
  }
}

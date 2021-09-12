import 'package:flutter/cupertino.dart';
import 'package:flutter_fruta/widgets/menu_list_tile.dart';
import 'package:flutter_fruta/widgets/recipe_card.dart';
import 'package:flutter_fruta/widgets/recipe_details.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RecipesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        const CupertinoSliverNavigationBar(
          largeTitle: Text('Recipes'),
        ),
        SliverSafeArea(
          sliver: SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, top: 0),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: RecipeCard(
                      imagePath: 'assets/smoothie/recipes-button-bg@1x.png',
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Container(
                      color: CupertinoColors.separator.darkHighContrastColor,
                      height: 0.5,
                    ),
                  ),
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: Hive.box('frutaFavourites').listenable(),
                      builder: (context, dynamic box, child) {
                        if (box.isEmpty) {
                          return Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Add some smoothies to your favourites to unlock their recipes',
                              style: CupertinoTheme.of(context)
                                  .textTheme
                                  .textStyle,
                            ),
                          );
                        }
                        return ListView.separated(
                          shrinkWrap: true,
                          itemCount: box.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            var favItem = box.values.toList();
                            return MenuListTile(
                              drinkName: favItem[index]['name'],
                              imagePath: favItem[index]['image'],
                              drinkCalories:
                                  favItem[index]['calories'].toString(),
                              ingredients: favItem[index]['ingredients'],
                              onTap: () => Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => RecipeDetails(
                                    drinkName: favItem[index]['name'],
                                    imagePath: favItem[index]['image'],
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Container(
                              color: CupertinoColors
                                  .separator.darkHighContrastColor,
                              height: 0.5,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

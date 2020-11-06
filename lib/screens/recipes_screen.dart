import 'package:flutter/cupertino.dart';
import 'package:flutter_fruta/widgets/recipe_card.dart';

class RecipesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        CupertinoSliverNavigationBar(
          largeTitle: Text('Recipes'),
        ),
        SliverSafeArea(
          sliver: SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  RecipeCard(
                    imagePath: 'assets/smoothie/recipes-button-bg@1x.png',
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

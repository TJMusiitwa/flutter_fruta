import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

var favBox = Hive.box('frutaFavourites');

class RecipeDetails extends StatefulWidget {
  final String? imagePath, drinkName;

  const RecipeDetails({super.key, this.imagePath, this.drinkName});
  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        CupertinoSliverNavigationBar(
          largeTitle: Text(widget.drinkName!),
          previousPageTitle: 'Recipes',
          trailing: CupertinoButton(
            onPressed: () {
              setState(() {
                if (favBox.containsKey(widget.drinkName)) {
                  favBox.delete(widget.drinkName);
                }
              });
            },
            child: favBox.containsKey(widget.drinkName)
                ? Icon(
                    CupertinoIcons.heart_solid,
                    color: CupertinoTheme.of(context).primaryColor,
                    size: 25,
                  )
                : Icon(
                    CupertinoIcons.heart,
                    color: CupertinoTheme.of(context).primaryColor,
                    size: 25,
                  ),
          ),
        ),
        SliverFillRemaining(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Hero(
                    tag: widget.drinkName!,
                    transitionOnUserGestures: true,
                    child: Container(
                      height: 300,
                      width: 368,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(24)),
                        image: DecorationImage(
                            image: AssetImage(widget.imagePath!),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Ingredients',
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .navTitleTextStyle
                      .copyWith(
                        color: CupertinoColors.systemGrey,
                        fontSize: 25,
                      ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(child: ListView())
              ],
            ),
          ),
        )
      ],
    );
  }
}

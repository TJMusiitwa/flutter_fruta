import 'dart:ui' show ImageFilter;

import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fruta/model/smoothie_model.dart';
import 'package:flutter_fruta/widgets/ingredient_widgets.dart';
import 'package:flutter_fruta/widgets/recipe_card.dart';
import 'package:hive/hive.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

var favBox = Hive.box('frutaFavourites');

class DrinkViewWidget extends StatelessWidget {
  const DrinkViewWidget({super.key, required this.smoothie});
  final Smoothie smoothie;

  static final cardKey = GlobalKey<FlipCardState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CupertinoScrollbar(
          child: NestedScrollView(
            headerSliverBuilder: (context, _) => [
              CupertinoSliverNavigationBar(
                largeTitle: Text(smoothie.smoothieName),
                previousPageTitle: 'Menu',
                trailing: FavouriteButton(smoothie: smoothie),
              ),
            ],
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        minHeight: 300,
                        maxHeight: MediaQuery.of(context).size.height / 1.5,
                        minWidth: MediaQuery.of(context).size.width),
                    child: Hero(
                      tag: smoothie.smoothieName,
                      transitionOnUserGestures: true,
                      child: Image.asset(
                        smoothie.imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: MediaQuery.platformBrightnessOf(context) ==
                                Brightness.dark
                            ? CupertinoColors.systemGrey6.darkColor
                            : CupertinoColors.systemGrey6),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            smoothie.description,
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .textStyle
                                .copyWith(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                ),
                          ),
                          Text(
                            '${smoothie.calories} calories',
                            maxLines: 1,
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .textStyle
                                .copyWith(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                    color: CupertinoColors.systemGrey),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      'Ingredients',
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .navTitleTextStyle
                          .copyWith(
                            color: CupertinoColors.systemGrey,
                            fontSize: 25,
                          ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8, right: 8, bottom: 90),
                    child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16),
                        itemCount: smoothie.ingredients.length,
                        itemBuilder: (context, index) {
                          var singleIngredient = smoothie.ingredients[index];
                          return GestureDetector(
                            onTap: () {
                              showCupertinoDialog(
                                context: context,
                                useRootNavigator: false,
                                builder: (_) => CupertinoPopupSurface(
                                  isSurfacePainted: true,
                                  child: Center(
                                    child: SizedBox(
                                      height: 500,
                                      width: 400,
                                      child: FlipCard(
                                        key: cardKey,
                                        flipOnTouch: false,
                                        front: FrontIngredientCard(
                                            singleIngredient: singleIngredient,
                                            cardKey: cardKey),
                                        back: BackIngredientCard(
                                            singleIngredient: singleIngredient,
                                            cardKey: cardKey),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: IngredientGridItem(
                                singleIngredient: singleIngredient),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 79,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 90,
            child: FrostyBackground(
              color: const Color(0xAAF2F2F2),
              child: Center(
                child: CupertinoButton.filled(
                  onPressed: () {
                    showCupertinoModalBottomSheet(
                      context: context,
                      expand: true,
                      backgroundColor: CupertinoColors.black,
                      useRootNavigator: true,
                      builder: (_) {
                        return PurchaseScreen(smoothieDetails: smoothie);
                      },
                    );
                  },
                  child: const Text('Buy with Apple Pay'),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FavouriteButton extends StatefulWidget {
  const FavouriteButton({super.key, required this.smoothie});

  final Smoothie smoothie;

  @override
  State<FavouriteButton> createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<FavouriteButton> {
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        HapticFeedback.mediumImpact();
        setState(() {
          if (favBox.containsKey(widget.smoothie.smoothieName)) {
            favBox.delete(widget.smoothie.smoothieName);
          } else {
            favBox.put(widget.smoothie.smoothieName, {
              'name': widget.smoothie.smoothieName,
              'image': widget.smoothie.imagePath,
              'calories': widget.smoothie.calories,
              'desc': widget.smoothie.description,
              'ingredients': [
                for (var item in widget.smoothie.ingredients)
                  item.localizedFoodItemNames.en
              ].join(', '),
            });
          }
        });
      },
      child: favBox.containsKey(widget.smoothie.smoothieName)
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
    );
  }
}

class PurchaseScreen extends StatelessWidget {
  const PurchaseScreen({super.key, required this.smoothieDetails});

  final Smoothie smoothieDetails;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          //height: MediaQuery.of(context).size.height / 1.4,
          decoration: BoxDecoration(
            color: CupertinoColors.white.withOpacity(0.0),
            image: DecorationImage(
                image: AssetImage(smoothieDetails.imagePath),
                fit: BoxFit.cover),
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: ColoredBox(
            color: CupertinoColors.systemGrey5.withOpacity(0.2),
          ),
        ),
        Align(
          child: Container(
            width: 300,
            height: 300,
            padding: const EdgeInsets.all(36),
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: CupertinoColors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'THANK YOU FOR YOUR ORDER!',
                  textAlign: TextAlign.center,
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .navLargeTitleTextStyle
                      .copyWith(
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.black),
                ),
                const SizedBox(height: 16),
                Text(
                  'We will notify you when your order is ready.',
                  textAlign: TextAlign.center,
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .textStyle
                      .copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 20,
                          color: CupertinoColors.systemGrey),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

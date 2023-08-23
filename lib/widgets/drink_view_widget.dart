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

class DrinkViewWidget extends StatefulWidget {
  final String? drinkName;

  const DrinkViewWidget({
    Key? key,
    required this.drinkName,
  }) : super(key: key);

  @override
  State<DrinkViewWidget> createState() => _DrinkViewWidgetState();
}

class _DrinkViewWidgetState extends State<DrinkViewWidget> {
  @override
  void initState() {
    super.initState();
    _fetchIngredientsData();
  }

  Future<String> _fetchIngredientsData() async {
    return await DefaultAssetBundle.of(context)
        .loadString('assets/smoothie_data.json');
  }

  @override
  Widget build(BuildContext context) {
    var cardKey = GlobalKey<FlipCardState>();
    return FutureBuilder(
      future: _fetchIngredientsData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final smoothieData = smoothieFromJson(snapshot.data.toString());
        var smoothieDetails = smoothieData
            .where((element) => element.smoothieName == widget.drinkName)
            .single;

        if (snapshot.connectionState == ConnectionState.waiting &&
            snapshot.data != null) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }

        if (snapshot.data == null) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }

        return snapshot.hasData
            ? Stack(
                children: [
                  CupertinoScrollbar(
                    child: NestedScrollView(
                      headerSliverBuilder: (context, _) => [
                        CupertinoSliverNavigationBar(
                          largeTitle: Text(widget.drinkName!),
                          previousPageTitle: 'Menu',
                          trailing: CupertinoButton(
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              setState(() {
                                if (favBox.containsKey(widget.drinkName)) {
                                  favBox.delete(widget.drinkName);
                                } else {
                                  favBox.put(widget.drinkName, {
                                    'name': widget.drinkName,
                                    'image': smoothieDetails.imagePath,
                                    'calories': smoothieDetails.calories,
                                    'desc': smoothieDetails.description,
                                    'ingredients': [
                                      for (var item
                                          in smoothieDetails.ingredients)
                                        item.localizedFoodItemNames.en
                                    ].join(', '),
                                  });
                                }
                              });
                            },
                            child: favBox.containsKey(widget.drinkName)
                                ? Icon(
                                    CupertinoIcons.heart_solid,
                                    color:
                                        CupertinoTheme.of(context).primaryColor,
                                    size: 25,
                                  )
                                : Icon(
                                    CupertinoIcons.heart,
                                    color:
                                        CupertinoTheme.of(context).primaryColor,
                                    size: 25,
                                  ),
                          ),
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
                                  maxHeight:
                                      MediaQuery.of(context).size.height / 1.5,
                                  minWidth: MediaQuery.of(context).size.width),
                              child: Hero(
                                tag: widget.drinkName!,
                                transitionOnUserGestures: true,
                                child: Image.asset(
                                  smoothieDetails.imagePath,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: MediaQuery.platformBrightnessOf(
                                              context) ==
                                          Brightness.dark
                                      ? CupertinoColors.systemGrey6.darkColor
                                      : CupertinoColors.systemGrey6),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      smoothieDetails.description,
                                      style: CupertinoTheme.of(context)
                                          .textTheme
                                          .textStyle
                                          .copyWith(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18,
                                          ),
                                    ),
                                    Text(
                                      '${smoothieDetails.calories} calories',
                                      maxLines: 1,
                                      style: CupertinoTheme.of(context)
                                          .textTheme
                                          .textStyle
                                          .copyWith(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 15,
                                              color:
                                                  CupertinoColors.systemGrey),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
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
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, bottom: 90),
                              child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 16,
                                          crossAxisSpacing: 16),
                                  itemCount: smoothieDetails.ingredients.length,
                                  itemBuilder: (context, index) {
                                    var singleIngredient =
                                        smoothieDetails.ingredients[index];
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
                                                      singleIngredient:
                                                          singleIngredient,
                                                      cardKey: cardKey),
                                                  back: BackIngredientCard(
                                                      singleIngredient:
                                                          singleIngredient,
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
                                  return PurchaseScreen(
                                      smoothieDetails: smoothieDetails);
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
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'There are no details about ${widget.drinkName}',
                    softWrap: true,
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .textStyle
                        .copyWith(fontSize: 25),
                  ),
                ),
              );
      },
    );
  }
}

class PurchaseScreen extends StatelessWidget {
  const PurchaseScreen({
    Key? key,
    required this.smoothieDetails,
  }) : super(key: key);

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
          child: Container(
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
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 16,
                ),
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

import 'dart:ui';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_fruta/model/smoothie_model.dart';

import 'package:flutter_fruta/widgets/recipe_card.dart';
import 'package:hive/hive.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

var favBox = Hive.box('frutaFavourites');

class DrinkViewWidget extends StatefulWidget {
  final String drinkName;

  const DrinkViewWidget({
    Key key,
    @required this.drinkName,
  }) : super(key: key);

  @override
  _DrinkViewWidgetState createState() => _DrinkViewWidgetState();
}

class _DrinkViewWidgetState extends State<DrinkViewWidget> {
  @override
  void initState() {
    super.initState();
    _fetchIngredientsData();
  }

  Future<void> _fetchIngredientsData() async {
    return await DefaultAssetBundle.of(context)
        .loadString("assets/smoothie_data.json");
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
    return FutureBuilder(
      future: _fetchIngredientsData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final smoothieData = smoothieFromJson(snapshot.data.toString());
        var smoothieDetails = smoothieData
            .where((element) => element.smoothieName == widget.drinkName)
            .single;

        if (snapshot.data == null) {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        }

        return snapshot.hasData == null
            ? Center(
                child: Text('There are no details about ${widget.drinkName}'),
              )
            : Stack(
                children: [
                  CupertinoScrollbar(
                    child: NestedScrollView(
                      headerSliverBuilder: (context, _) => [
                        CupertinoSliverNavigationBar(
                          largeTitle: Text(widget.drinkName),
                          previousPageTitle: 'Menu',
                          trailing: CupertinoButton(
                            onPressed: () {
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
                                tag: widget.drinkName,
                                child: Image.asset(
                                  smoothieDetails.imagePath,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: CupertinoColors.systemGrey6),
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
                                      "${smoothieDetails.calories} calories",
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
                            SizedBox(
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
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
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
                                          builder: (_) => Center(
                                            child: CupertinoPopupSurface(
                                              isSurfacePainted: true,
                                              child: Container(
                                                height: 500,
                                                width: 400,
                                                child: FlipCard(
                                                  flipOnTouch: true,
                                                  front: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Positioned.fill(
                                                        child: Hero(
                                                          tag: singleIngredient
                                                              .identifier,
                                                          child: Image.asset(
                                                              'assets/ingredients/${singleIngredient.identifier}.jpg',
                                                              fit:
                                                                  BoxFit.cover),
                                                        ),
                                                      ),
                                                      Positioned(
                                                          top: 6,
                                                          right: 6,
                                                          child: CupertinoButton(
                                                              child: Icon(
                                                                  CupertinoIcons
                                                                      .clear_circled_solid,
                                                                  size: 40,
                                                                  color: CupertinoColors
                                                                      .inactiveGray
                                                                      .withOpacity(
                                                                          0.7)),
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context))),
                                                      Positioned(
                                                        bottom: 6,
                                                        right: 6,
                                                        child: CupertinoButton(
                                                          child: Icon(
                                                              CupertinoIcons
                                                                  .info_circle_fill,
                                                              size: 40,
                                                              color: CupertinoColors
                                                                  .inactiveGray
                                                                  .withOpacity(
                                                                      0.7)),
                                                          //TODO: Fix the toggle card button => https://pub.dev/packages/flip_card
                                                          onPressed: () =>
                                                              cardKey
                                                                  .currentState
                                                                  .toggleCard(),
                                                        ),
                                                      ),
                                                      Text(
                                                        singleIngredient
                                                            .localizedFoodItemNames
                                                            .en
                                                            .toUpperCase(),
                                                        textScaleFactor: 1.5,
                                                        textAlign:
                                                            TextAlign.center,
                                                        softWrap: true,
                                                        style: CupertinoTheme
                                                                .of(context)
                                                            .textTheme
                                                            .textStyle
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 40,
                                                                foreground:
                                                                    Paint()
                                                                      ..blendMode =
                                                                          BlendMode
                                                                              .softLight
                                                                      ..color =
                                                                          CupertinoColors
                                                                              .black),
                                                      ),
                                                    ],
                                                  ),
                                                  //TODO: For back Stack and blur the background before laying on nutrition information
                                                  back: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Nutrition Facts',
                                                        style:
                                                            CupertinoTheme.of(
                                                                    context)
                                                                .textTheme
                                                                .textStyle,
                                                      ),
                                                      Text(
                                                          'Serving Size 1 Cup'),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text('112 calories')
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 180,
                                        width: 180,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child: Hero(
                                                tag:
                                                    singleIngredient.identifier,
                                                child: Image.asset(
                                                    'assets/ingredients/${singleIngredient.identifier}.jpg',
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                            Text(
                                              singleIngredient
                                                  .localizedFoodItemNames.en
                                                  .toUpperCase(),
                                              textScaleFactor: 0.8,
                                              textAlign: TextAlign.center,
                                              softWrap: true,
                                              style: CupertinoTheme.of(context)
                                                  .textTheme
                                                  .textStyle
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 40,
                                                      foreground: Paint()
                                                        ..blendMode =
                                                            BlendMode.softLight
                                                        ..color =
                                                            CupertinoColors
                                                                .black),
                                            ),
                                          ],
                                        ),
                                      ),
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
                    child: Container(
                      height: 90,
                      child: FrostyBackground(
                        color: Color(0xAAF2F2F2),
                        child: Center(
                          child: CupertinoButton.filled(
                            child: Text('Buy with Apple Pay'),
                            onPressed: () {
                              showCupertinoModalBottomSheet(
                                context: context,
                                expand: true,
                                backgroundColor: CupertinoColors.black,
                                builder: (_, __) {
                                  return PurchaseScreen(
                                      smoothieDetails: smoothieDetails);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
      },
    );
  }
}

class PurchaseScreen extends StatelessWidget {
  const PurchaseScreen({
    Key key,
    @required this.smoothieDetails,
  }) : super(key: key);

  final Smoothie smoothieDetails;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          //height: MediaQuery.of(context).size.height / 1.4,
          decoration: new BoxDecoration(
            color: CupertinoColors.white.withOpacity(0.0),
            image: DecorationImage(
                image: AssetImage(smoothieDetails.imagePath),
                fit: BoxFit.cover),
          ),
        ),
        Container(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: CupertinoColors.systemGrey5.withOpacity(0.2),
            ),
          ),
        ),
        Align(
          child: Container(
            width: 300,
            height: 300,
            padding: const EdgeInsets.all(36),
            decoration: BoxDecoration(
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
                SizedBox(
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

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
                                          builder: (_) => CupertinoPopupSurface(
                                            isSurfacePainted: true,
                                            child: Center(
                                              child: Container(
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

class IngredientGridItem extends StatelessWidget {
  const IngredientGridItem({
    Key key,
    @required this.singleIngredient,
  }) : super(key: key);

  final Ingredient singleIngredient;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Hero(
              tag: singleIngredient.identifier,
              child: Image.asset(
                  'assets/ingredients/${singleIngredient.identifier}.jpg',
                  fit: BoxFit.cover),
            ),
          ),
          Text(
            singleIngredient.localizedFoodItemNames.en.toUpperCase(),
            textScaleFactor: 0.8,
            textAlign: TextAlign.center,
            softWrap: true,
            style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 40,
                foreground: Paint()
                  ..blendMode = BlendMode.softLight
                  ..color = CupertinoColors.black),
          ),
        ],
      ),
    );
  }
}

class BackIngredientCard extends StatelessWidget {
  const BackIngredientCard({
    Key key,
    @required this.singleIngredient,
    @required this.cardKey,
  }) : super(key: key);

  final Ingredient singleIngredient;
  final GlobalKey<FlipCardState> cardKey;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Image.asset(
                'assets/ingredients/${singleIngredient.identifier}.jpg',
                fit: BoxFit.cover,
                height: 500,
                width: 400,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nutrition Facts',
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .navTitleTextStyle
                      .copyWith(fontSize: 35),
                ),
                Text(
                  'Serving Size 1 Cup',
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .textStyle
                      .copyWith(fontSize: 15),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '112 calories',
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .textStyle
                      .copyWith(fontSize: 20, fontWeight: FontWeight.w400),
                ),
                Container(
                  height: 1,
                  color: CupertinoColors.separator,
                ),
                NutritionFactsList(singleIngredient: singleIngredient),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 70,
              //color: Color(0xfffff). //Color(0x90ffffff),
              child: Row(
                children: [
                  Spacer(),
                  CupertinoButton(
                    child: Icon(CupertinoIcons.arrow_left_circle_fill,
                        size: 40,
                        color: CupertinoColors.inactiveGray.withOpacity(0.7)),
                    onPressed: () => cardKey.currentState.toggleCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FrontIngredientCard extends StatelessWidget {
  const FrontIngredientCard({
    Key key,
    @required this.singleIngredient,
    @required this.cardKey,
  }) : super(key: key);

  final Ingredient singleIngredient;
  final GlobalKey<FlipCardState> cardKey;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Hero(
              tag: singleIngredient.identifier,
              child: Image.asset(
                  'assets/ingredients/${singleIngredient.identifier}.jpg',
                  fit: BoxFit.cover),
            ),
          ),
          Positioned(
              top: 6,
              right: 6,
              child: CupertinoButton(
                  child: Icon(CupertinoIcons.clear_circled_solid,
                      size: 40,
                      color: CupertinoColors.inactiveGray.withOpacity(0.7)),
                  onPressed: () => Navigator.pop(context))),
          Positioned(
            bottom: 6,
            right: 6,
            child: CupertinoButton(
              child: Icon(CupertinoIcons.info_circle_fill,
                  size: 40,
                  color: CupertinoColors.inactiveGray.withOpacity(0.7)),
              onPressed: () => cardKey.currentState.toggleCard(),
            ),
          ),
          Text(
            singleIngredient.localizedFoodItemNames.en.toUpperCase(),
            textScaleFactor: 1.5,
            textAlign: TextAlign.center,
            softWrap: true,
            style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 40,
                foreground: Paint()
                  ..blendMode = BlendMode.softLight
                  ..color = CupertinoColors.black),
          ),
        ],
      ),
    );
  }
}

class NutritionFactsList extends StatelessWidget {
  const NutritionFactsList({
    Key key,
    @required this.singleIngredient,
  }) : super(key: key);

  final Ingredient singleIngredient;

  @override
  Widget build(BuildContext context) {
    return CupertinoScrollbar(
      child: ListView(
        padding: EdgeInsets.only(left: 5, right: 5),
        shrinkWrap: true,
        children: [
          NutritionRow(
            leftMargin: EdgeInsets.zero,
            nutritionFact: 'Total Fat',
            nutritionQty: singleIngredient.totalSaturatedFat,
          ),
          NutritionSeparator(),
          NutritionRow(
            nutritionFact: 'Total Saturated Fat',
            nutritionQty: singleIngredient.totalSaturatedFat,
          ),
          NutritionSeparator(),
          NutritionRow(
            nutritionFact: 'Total Monounsaturated Fat',
            nutritionQty: singleIngredient.totalMonounsaturatedFat,
          ),
          NutritionSeparator(),
          NutritionRow(
            nutritionFact: 'Total Polyunsaturated Fat',
            nutritionQty: singleIngredient.totalPolyunsaturatedFat,
          ),
          NutritionSeparator(),
          NutritionRow(
            leftMargin: EdgeInsets.zero,
            nutritionFact: 'Cholestral',
            nutritionQty: singleIngredient.cholesterol,
          ),
          NutritionSeparator(),
          NutritionRow(
            leftMargin: EdgeInsets.zero,
            nutritionFact: 'Sodium',
            nutritionQty: singleIngredient.sodium,
          ),
          NutritionSeparator(),
          NutritionRow(
            leftMargin: EdgeInsets.zero,
            nutritionFact: 'Total Carbohydrates',
            nutritionQty: singleIngredient.totalCarbohydrates,
          ),
          NutritionSeparator(),
          NutritionRow(
            nutritionFact: 'Dietary Fiber',
            nutritionQty: singleIngredient.dietaryFiber,
          ),
          NutritionSeparator(),
          NutritionRow(
            nutritionFact: 'Sugar',
            nutritionQty: singleIngredient.sugar,
          ),
          NutritionSeparator(),
          NutritionRow(
            leftMargin: EdgeInsets.zero,
            nutritionFact: 'Protein',
            nutritionQty: singleIngredient.protein,
          ),
          NutritionSeparator(),
          NutritionRow(
            leftMargin: EdgeInsets.zero,
            nutritionFact: 'Calcium',
            nutritionQty: singleIngredient.calcium,
          ),
          NutritionSeparator(),
          NutritionRow(
            leftMargin: EdgeInsets.zero,
            nutritionFact: 'Potassium',
            nutritionQty: singleIngredient.potassium,
          ),
          NutritionSeparator(),
          NutritionRow(
            leftMargin: EdgeInsets.zero,
            nutritionFact: 'Vitamin A',
            nutritionQty: singleIngredient.vitaminA,
          ),
          NutritionSeparator(),
          NutritionRow(
            leftMargin: EdgeInsets.zero,
            nutritionFact: 'Vitamin C',
            nutritionQty: singleIngredient.vitaminC,
          ),
          NutritionSeparator(),
          NutritionRow(
            leftMargin: EdgeInsets.zero,
            nutritionFact: 'Iron',
            nutritionQty: singleIngredient.iron,
          ),
          NutritionSeparator(),
        ],
      ),
    );
  }
}

class NutritionRow extends StatelessWidget {
  final String nutritionFact, nutritionQty;
  final EdgeInsets leftMargin;
  const NutritionRow({
    Key key,
    @required this.nutritionFact,
    @required this.nutritionQty,
    this.leftMargin = const EdgeInsets.only(left: 16),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      margin: leftMargin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(nutritionFact), Text(nutritionQty)],
      ),
    );
  }
}

class NutritionSeparator extends StatelessWidget {
  const NutritionSeparator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.5,
      color: CupertinoColors.separator,
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

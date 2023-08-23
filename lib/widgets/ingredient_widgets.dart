import 'dart:ui' show ImageFilter;

import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_fruta/model/smoothie_model.dart';

class BackIngredientCard extends StatelessWidget {
  final Ingredient singleIngredient;

  final GlobalKey<FlipCardState> cardKey;
  const BackIngredientCard({
    Key? key,
    required this.singleIngredient,
    required this.cardKey,
  }) : super(key: key);

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
                const SizedBox(
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
            child: SizedBox(
              height: 70,
              //color: Color(0xfffff). //Color(0x90ffffff),
              child: Row(
                children: [
                  const Spacer(),
                  CupertinoButton(
                    onPressed: () => cardKey.currentState!.toggleCard(),
                    child: Icon(CupertinoIcons.arrow_left_circle_fill,
                        size: 40,
                        color: CupertinoColors.inactiveGray.withOpacity(0.7)),
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
  final Ingredient singleIngredient;

  final GlobalKey<FlipCardState> cardKey;
  const FrontIngredientCard({
    Key? key,
    required this.singleIngredient,
    required this.cardKey,
  }) : super(key: key);

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
              onPressed: () => Navigator.pop(context),
              child: Icon(CupertinoIcons.clear_circled_solid,
                  size: 40,
                  color: CupertinoColors.inactiveGray.withOpacity(0.7)),
            ),
          ),
          Positioned(
            bottom: 6,
            right: 6,
            child: CupertinoButton(
              onPressed: () => cardKey.currentState!.toggleCard(),
              child: Icon(CupertinoIcons.info_circle_fill,
                  size: 40,
                  color: CupertinoColors.inactiveGray.withOpacity(0.7)),
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

class IngredientGridItem extends StatelessWidget {
  final Ingredient singleIngredient;

  const IngredientGridItem({
    Key? key,
    required this.singleIngredient,
  }) : super(key: key);

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

class NutritionFactsList extends StatelessWidget {
  final Ingredient singleIngredient;

  const NutritionFactsList({
    Key? key,
    required this.singleIngredient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoScrollbar(
      child: ListView(
        padding: const EdgeInsets.only(left: 5, right: 5),
        shrinkWrap: true,
        children: [
          NutritionRow(
            leftMargin: EdgeInsets.zero,
            nutritionFact: 'Total Fat',
            nutritionQty: singleIngredient.totalSaturatedFat,
          ),
          const NutritionSeparator(),
          NutritionRow(
            nutritionFact: 'Total Saturated Fat',
            nutritionQty: singleIngredient.totalSaturatedFat,
          ),
          const NutritionSeparator(),
          NutritionRow(
            nutritionFact: 'Total Monounsaturated Fat',
            nutritionQty: singleIngredient.totalMonounsaturatedFat,
          ),
          const NutritionSeparator(),
          NutritionRow(
            nutritionFact: 'Total Polyunsaturated Fat',
            nutritionQty: singleIngredient.totalPolyunsaturatedFat,
          ),
          const NutritionSeparator(),
          NutritionRow(
            leftMargin: EdgeInsets.zero,
            nutritionFact: 'Cholestral',
            nutritionQty: singleIngredient.cholesterol,
          ),
          const NutritionSeparator(),
          NutritionRow(
            leftMargin: EdgeInsets.zero,
            nutritionFact: 'Sodium',
            nutritionQty: singleIngredient.sodium,
          ),
          const NutritionSeparator(),
          NutritionRow(
            leftMargin: EdgeInsets.zero,
            nutritionFact: 'Total Carbohydrates',
            nutritionQty: singleIngredient.totalCarbohydrates,
          ),
          const NutritionSeparator(),
          NutritionRow(
            nutritionFact: 'Dietary Fiber',
            nutritionQty: singleIngredient.dietaryFiber,
          ),
          const NutritionSeparator(),
          NutritionRow(
            nutritionFact: 'Sugar',
            nutritionQty: singleIngredient.sugar,
          ),
          const NutritionSeparator(),
          NutritionRow(
            leftMargin: EdgeInsets.zero,
            nutritionFact: 'Protein',
            nutritionQty: singleIngredient.protein,
          ),
          const NutritionSeparator(),
          NutritionRow(
            leftMargin: EdgeInsets.zero,
            nutritionFact: 'Calcium',
            nutritionQty: singleIngredient.calcium,
          ),
          const NutritionSeparator(),
          NutritionRow(
            leftMargin: EdgeInsets.zero,
            nutritionFact: 'Potassium',
            nutritionQty: singleIngredient.potassium,
          ),
          const NutritionSeparator(),
          NutritionRow(
            leftMargin: EdgeInsets.zero,
            nutritionFact: 'Vitamin A',
            nutritionQty: singleIngredient.vitaminA,
          ),
          const NutritionSeparator(),
          NutritionRow(
            leftMargin: EdgeInsets.zero,
            nutritionFact: 'Vitamin C',
            nutritionQty: singleIngredient.vitaminC,
          ),
          const NutritionSeparator(),
          NutritionRow(
            leftMargin: EdgeInsets.zero,
            nutritionFact: 'Iron',
            nutritionQty: singleIngredient.iron,
          ),
          const NutritionSeparator(),
        ],
      ),
    );
  }
}

class NutritionRow extends StatelessWidget {
  final String? nutritionFact, nutritionQty;
  final EdgeInsets leftMargin;
  const NutritionRow({
    Key? key,
    required this.nutritionFact,
    required this.nutritionQty,
    this.leftMargin = const EdgeInsets.only(left: 16),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      margin: leftMargin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(nutritionFact!), Text(nutritionQty!)],
      ),
    );
  }
}

class NutritionSeparator extends StatelessWidget {
  const NutritionSeparator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.5,
      color: CupertinoColors.separator,
    );
  }
}

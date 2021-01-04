import 'dart:ui';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_fruta/model/smoothie_model.dart';

import 'package:flutter_fruta/widgets/recipe_card.dart';
import 'package:hive/hive.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

var favBox = Hive.box('frutaFavourites');

class DrinkViewWidget extends StatefulWidget {
  final String imagePath, drinkDesc, drinkName, drinkCalories, ingredients;

  const DrinkViewWidget(
      {Key key,
      @required this.imagePath,
      @required this.drinkDesc,
      @required this.drinkName,
      @required this.drinkCalories,
      this.ingredients})
      : super(key: key);

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
    return CustomScrollView(
      slivers: <Widget>[
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
                    'image': widget.imagePath,
                    'calories': widget.drinkCalories,
                    'desc': widget.drinkDesc,
                    'ingredients': widget.ingredients
                  });
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
        SliverSafeArea(
          top: false,
          sliver: SliverFillRemaining(
              child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          minHeight: 300,
                          maxHeight: MediaQuery.of(context).size.height / 1.5,
                          minWidth: MediaQuery.of(context).size.width),
                      child: Hero(
                        tag: widget.drinkName,
                        child: Image.asset(
                          widget.imagePath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      decoration:
                          BoxDecoration(color: CupertinoColors.systemGrey6),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              widget.drinkDesc,
                              style: CupertinoTheme.of(context)
                                  .textTheme
                                  .textStyle
                                  .copyWith(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18,
                                  ),
                            ),
                            Text(
                              "${widget.drinkCalories} calories",
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
                    SizedBox(
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
                    SizedBox(
                      height: 15,
                    ),
                    // FutureBuilder(
                    //   future: _fetchIngredientsData(),
                    //   builder: (BuildContext context, AsyncSnapshot snapshot) {
                    //     final ingredients =
                    //         ingredientsFromJson(snapshot.data.toString());
                    //     return GridView.builder(
                    //         gridDelegate:
                    //             SliverGridDelegateWithFixedCrossAxisCount(
                    //           crossAxisCount: 2,
                    //           mainAxisSpacing: 5,
                    //         ),
                    //         itemCount: ingredients.length,
                    //         itemBuilder: (context, index) {
                    //           var singleIngredient = ingredients[index];
                    //           return CupertinoPopupSurface(
                    //             isSurfacePainted: false,
                    //             child: FlipCard(
                    //                 front: Container(
                    //                   decoration: BoxDecoration(
                    //                       image: DecorationImage(
                    //                           image: AssetImage(
                    //                               'assets/ingredients/${singleIngredient.identifier}.jpg'),
                    //                           fit: BoxFit.cover)),
                    //                 ),
                    //                 back: null),
                    //           );
                    //         });
                    //   },
                    // ),
                  ],
                ),
              ),
              Positioned(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 0,
                right: 0,
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
                            return Stack(
                              children: [
                                Container(
                                  //height: MediaQuery.of(context).size.height / 1.4,
                                  decoration: new BoxDecoration(
                                    color:
                                        CupertinoColors.white.withOpacity(0.0),
                                    image: DecorationImage(
                                        image: AssetImage(widget.imagePath),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                Container(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 10, sigmaY: 10),
                                    child: Container(
                                      color: CupertinoColors.systemGrey5
                                          .withOpacity(0.2),
                                    ),
                                  ),
                                ),
                                Align(
                                  child: Container(
                                    width: 300,
                                    height: 300,
                                    padding: const EdgeInsets.all(36),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: CupertinoColors.white),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'THANK YOU FOR YOUR ORDER!',
                                          textAlign: TextAlign.center,
                                          style: CupertinoTheme.of(context)
                                              .textTheme
                                              .navLargeTitleTextStyle
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
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
                                                  color: CupertinoColors
                                                      .systemGrey),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
              // CupertinoButton.filled(
              //   child: Text('Buy with Apple Pay'),
              //   onPressed: () {},
              // ),
            ],
          )),
        ),
      ],
    );
  }
}

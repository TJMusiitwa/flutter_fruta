import 'dart:ui';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Color, Colors;

import 'package:flutter_fruta/widgets/recipe_card.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DrinkViewWidget extends StatelessWidget {
  final String imagePath, drinkDesc, drinkName, drinkCalories;

  const DrinkViewWidget(
      {Key key,
      @required this.imagePath,
      @required this.drinkDesc,
      @required this.drinkName,
      @required this.drinkCalories})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        CupertinoSliverNavigationBar(
          largeTitle: Text(drinkName),
          previousPageTitle: 'Menu',
          trailing: CupertinoButton(
            onPressed: () {},
            child: Icon(
              CupertinoIcons.heart,
              color: CupertinoTheme.of(context).primaryColor,
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
                top: MediaQuery.of(context).padding.top,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          minHeight: 300,
                          maxHeight: 450,
                          minWidth: MediaQuery.of(context).size.width),
                      child: Hero(
                        tag: drinkName,
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      decoration:
                          BoxDecoration(color: CupertinoColors.systemGrey),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              drinkDesc,
                              style: CupertinoTheme.of(context)
                                  .textTheme
                                  .textStyle
                                  .copyWith(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18,
                                  ),
                            ),
                            Text(
                              "$drinkCalories calories",
                              maxLines: 1,
                              style: CupertinoTheme.of(context)
                                  .textTheme
                                  .textStyle
                                  .copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: CupertinoColors.systemGrey4),
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
                    // GridView.builder(
                    //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //       crossAxisCount: 2,
                    //       mainAxisSpacing: 5,
                    //     ),
                    //     itemBuilder: (context, index) {
                    //       return CupertinoPopupSurface(
                    //         isSurfacePainted: false,
                    //         child: FlipCard(front: null, back: null),
                    //       );
                    //     })
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
                          builder: (context, controller) => Container(
                            child: new BackdropFilter(
                              filter: new ImageFilter.blur(
                                  sigmaX: 20.0, sigmaY: 20.0),
                              child: new Container(
                                decoration: new BoxDecoration(
                                  color: Colors.white.withOpacity(0.0),
                                  image: DecorationImage(
                                      image: AssetImage(imagePath),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ),
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

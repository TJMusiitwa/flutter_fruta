import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Color, Colors;

import 'package:flutter_fruta/widgets/recipe_card.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DrinkViewWidget extends StatelessWidget {
  final String imagePath, drinkDesc, drinkName;

  const DrinkViewWidget(
      {Key key,
      @required this.imagePath,
      @required this.drinkDesc,
      @required this.drinkName})
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
          sliver: SliverFillRemaining(
              child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: MediaQuery.of(context).padding.top,
                child: ConstrainedBox(
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
              ),

              Text(
                'Ingredients',
                style: CupertinoTheme.of(context)
                    .textTheme
                    .actionTextStyle
                    .copyWith(color: CupertinoColors.systemGrey),
              ),
              Positioned(
                bottom: MediaQuery.of(context).padding.bottom,
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

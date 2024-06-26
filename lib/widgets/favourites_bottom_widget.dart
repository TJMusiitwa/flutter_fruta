import 'dart:ui';

import 'package:flutter/cupertino.dart';

class FavouritesBottomWidget extends StatelessWidget {
  final String? name, calories, imagePath, desc, ing;

  const FavouritesBottomWidget(
      {super.key,
      this.imagePath,
      this.name,
      this.calories,
      this.desc,
      this.ing});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height / 2.5,
      width: MediaQuery.sizeOf(context).width,
      child: PhysicalModel(
        color: CupertinoTheme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(10.0),
        elevation: 3,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height / 3.5,
                    width: MediaQuery.sizeOf(context).width,
                    child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        child: Image.asset(
                          imagePath!,
                          // color: CupertinoColors.systemGrey2,
                          // colorBlendMode: BlendMode.darken,
                          fit: BoxFit.cover,
                        )),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 10,
                    right: 20,
                    child: Text(
                      name!,
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .navLargeTitleTextStyle
                          .copyWith(color: CupertinoColors.white),
                    ),
                  ),
                  Positioned(
                      top: 6.0,
                      right: 6.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 16.0,
                            ),
                            decoration: BoxDecoration(
                                color: CupertinoTheme.of(context)
                                    .primaryColor
                                    .withOpacity(0.6)),
                            child: Text(
                              '$calories Cal',
                              style: CupertinoTheme.of(context)
                                  .textTheme
                                  .actionTextStyle
                                  .copyWith(
                                    color: CupertinoColors.white,
                                  ),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
              //SizedBox(height: 7.0),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                width: MediaQuery.of(context).size.width,
                child: Text('Ingredients: $ing',
                    softWrap: true,
                    textAlign: TextAlign.start,
                    style: CupertinoTheme.of(context).textTheme.textStyle),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                width: MediaQuery.of(context).size.width,
                child: Text(desc!,
                    softWrap: true,
                    textAlign: TextAlign.start,
                    style: CupertinoTheme.of(context).textTheme.textStyle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

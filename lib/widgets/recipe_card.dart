import 'dart:ui';

import 'package:flutter/cupertino.dart';

class FrostyBackground extends StatelessWidget {
  const FrostyBackground({
    this.color,
    this.intensity = 25,
    this.child,
  });

  final Color? color;
  final double intensity;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: intensity, sigmaY: intensity),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: MediaQuery.of(context).platformBrightness == Brightness.light
                ? const Color(0x90ffffff)
                : CupertinoColors.darkBackgroundGray,
          ),
          child: child,
        ),
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final String? imagePath;

  const RecipeCard({Key? key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: CupertinoColors.lightBackgroundGray,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      shadowColor: CupertinoColors.black,
      elevation: 15,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Stack(
          children: [
            Container(
              height: 250,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover, image: AssetImage(imagePath!))),
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: FrostyBackground(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Unlock All Recipes',
                          style: CupertinoTheme.of(context)
                              .textTheme
                              .navTitleTextStyle
                              .copyWith(fontSize: 23),
                        ),
                        Text(
                          'Loading...',
                          style: CupertinoTheme.of(context)
                              .textTheme
                              .textStyle
                              .copyWith(color: CupertinoColors.systemGrey),
                        ),
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

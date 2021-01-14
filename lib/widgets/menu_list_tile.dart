import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class MenuListTile extends StatelessWidget {
  final String imagePath, drinkName, drinkCalories, ingredients;
  final VoidCallback onTap;

  const MenuListTile(
      {Key key,
      this.imagePath,
      this.drinkName,
      this.drinkCalories,
      this.onTap,
      this.ingredients})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SafeArea(
        top: false,
        bottom: false,
        minimum: const EdgeInsets.only(
          left: 16,
          top: 8,
          bottom: 8,
          right: 8,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Hero(
                tag: drinkName,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      drinkName,
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .navTitleTextStyle
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      ingredients,
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .textStyle
                          .copyWith(fontWeight: FontWeight.w400),
                    ),
                    Text(
                      "$drinkCalories calories",
                      maxLines: 1,
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .textStyle
                          .copyWith(
                              fontWeight: FontWeight.normal,
                              color: CupertinoColors.systemGrey),
                    ),
                  ],
                ),
              ),
            ),
            //Spacer(),
            Center(
              child: Icon(CupertinoIcons.chevron_forward),
            )
          ],
        ),
      ),
    );
  }
}

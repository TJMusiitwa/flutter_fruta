import 'package:flutter/cupertino.dart';

class MenuListTile extends StatelessWidget {
  final String? imagePath, drinkName, drinkCalories, ingredients;
  final VoidCallback? onTap;

  const MenuListTile(
      {super.key,
      this.imagePath,
      this.drinkName,
      this.drinkCalories,
      this.onTap,
      this.ingredients});
  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      padding: const EdgeInsets.only(
        left: 16,
        top: 8,
        bottom: 8,
        right: 8,
      ),
      leadingSize: 100,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Hero(
          tag: drinkName!,
          transitionOnUserGestures: true,
          child: Image.asset(
            imagePath!,
            fit: BoxFit.cover,
            width: 100,
            height: 100,
          ),
        ),
      ),
      title: Text(
        drinkName!,
        style: CupertinoTheme.of(context)
            .textTheme
            .navTitleTextStyle
            .copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ingredients!,
            softWrap: true,
            maxLines: 2,
            style: CupertinoTheme.of(context)
                .textTheme
                .textStyle
                .copyWith(fontWeight: FontWeight.w400),
          ),
          Text(
            '$drinkCalories calories',
            maxLines: 1,
            style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                fontWeight: FontWeight.normal,
                color: CupertinoColors.systemGrey),
          ),
        ],
      ),
      trailing: const Center(
        child: Icon(CupertinoIcons.chevron_forward),
      ),
      onTap: onTap,
    );
  }
}

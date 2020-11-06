import 'package:flutter/cupertino.dart';

class FavouritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        CupertinoSliverNavigationBar(
          largeTitle: Text('Favourites'),
        ),
        SliverSafeArea(
          sliver: SliverFillRemaining(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Add some smoothies to your favourites',
                style: CupertinoTheme.of(context).textTheme.textStyle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

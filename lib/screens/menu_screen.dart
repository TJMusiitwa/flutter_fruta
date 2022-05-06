import 'package:flutter/cupertino.dart';
import 'package:flutter_fruta/model/smoothie_model.dart';
import 'package:flutter_fruta/widgets/drink_view_widget.dart';
import 'package:flutter_fruta/widgets/menu_list_tile.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    super.initState();
    _fetchSmoothieData();
  }

  Future<String> _fetchSmoothieData() async {
    return await DefaultAssetBundle.of(context)
        .loadString('assets/smoothie_data.json');
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          const CupertinoSliverNavigationBar(
            largeTitle: Text('Menu'),
          ),
        ];
      },
      body: FutureBuilder(
        future: _fetchSmoothieData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              snapshot.data != null) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
          if (snapshot.hasError) {
            debugPrint(snapshot.error.toString());
          }

          if (snapshot.data == null) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }

          final smoothie = smoothieFromJson(snapshot.data.toString());

          return snapshot.hasData
              ? CupertinoScrollbar(
                  child: ListView.separated(
                    itemCount: smoothie.length,
                    itemBuilder: (BuildContext context, int index) {
                      var smoothieItem = smoothie[index];
                      var _ingredients = [
                        for (final i in smoothieItem.ingredients!)
                          i.localizedFoodItemNames!.en
                      ].join(', ');

                      return MenuListTile(
                        drinkName: smoothieItem.smoothieName,
                        imagePath: smoothieItem.imagePath,
                        drinkCalories: smoothieItem.calories.toString(),
                        ingredients: _ingredients,
                        onTap: () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => DrinkViewWidget(
                                    drinkName: smoothieItem.smoothieName,
                                  )),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Container(
                        color: CupertinoColors.separator.darkHighContrastColor,
                        height: 0.5,
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    'There are no smoothies to show',
                    softWrap: true,
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .textStyle
                        .copyWith(fontSize: 25),
                  ),
                );
        },
      ),
    );
  }
}

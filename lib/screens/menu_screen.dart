import 'dart:convert' show json;

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

  Future<void> _fetchSmoothieData() async {
    return await DefaultAssetBundle.of(context)
        .loadString("assets/smoothie_data.json");
  }

  List<Ingredient> ingredientsFromJson(String str) => List<Ingredient>.from(
      json.decode(str).map((x) => Ingredient.fromJson(x)));

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          CupertinoSliverNavigationBar(
            largeTitle: Text('Menu'),
          ),
        ];
      },
      body: FutureBuilder(
        future: _fetchSmoothieData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              snapshot.data != null) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
          if (snapshot.hasError) {
            print(snapshot.error.toString());
          }

          if (snapshot.data == null) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
          //var values = snapshot.data;
          final smoothie = smoothieFromJson(snapshot.data.toString());

          return snapshot.hasData == null
              ? Center(
                  child: Text('There are no smoothies to show'),
                )
              : CupertinoScrollbar(
                  child: ListView.separated(
                    itemCount: smoothie.length,
                    itemBuilder: (BuildContext context, int index) {
                      var smoothieItem = smoothie[index];
                      //var ingItem = smoothieItem.ingredients['name'];
                      //var ingLength = smoothieItem.ingredients.length;
                      // for (var i = 0; i < smoothieItem.ingredients.length; i++) {

                      //   }

                      return MenuListTile(
                        drinkName: smoothieItem.smoothieName,
                        imagePath: smoothieItem.imagePath,
                        drinkCalories: smoothieItem.calories.toString(),
                        ingredients: "",
                        onTap: () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => DrinkViewWidget(
                                    imagePath: smoothieItem.imagePath,
                                    drinkDesc: smoothieItem.description,
                                    drinkName: smoothieItem.smoothieName,
                                    drinkCalories:
                                        smoothieItem.calories.toString(),
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
                );
        },
      ),
    );
  }
}

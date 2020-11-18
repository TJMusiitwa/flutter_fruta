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
    fetchSmoothieData();
  }

  Future<void> fetchSmoothieData() async {
    return DefaultAssetBundle.of(context)
        .loadString("assets/smoothie_data.json");
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        CupertinoSliverNavigationBar(
          largeTitle: Text('Menu'),
        ),
        SliverPadding(
          padding:
              MediaQuery.of(context).removePadding(removeTop: true).padding,
          sliver: SliverFillRemaining(
              child: FutureBuilder(
            future: fetchSmoothieData(),
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
              var values = snapshot.data;
              final smoothie = smoothieFromJson(values.toString());
              return snapshot.hasData == null
                  ? CupertinoActivityIndicator()
                  : CupertinoScrollbar(
                      child: ListView.separated(
                        itemCount: smoothie.length,
                        itemBuilder: (BuildContext context, int index) {
                          var smoothieItem = smoothie[index];
                          return MenuListTile(
                            drinkName: smoothieItem.smoothieName,
                            imagePath: smoothieItem.imagePath,
                            drinkCalories: smoothieItem.calories.toString(),
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
                            color:
                                CupertinoColors.separator.darkHighContrastColor,
                            height: 0.5,
                          ),
                        ),
                      ),
                    );
            },
          )),
        ),
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter_fruta/macos_screens/drink_details.dart';
import 'package:flutter_fruta/model/smoothie_model.dart';
import 'package:flutter_fruta/widgets/mac_card.dart';
import 'package:macos_ui/macos_ui.dart';

class MacosMenuScreen extends StatefulWidget {
  const MacosMenuScreen({Key? key}) : super(key: key);

  @override
  State<MacosMenuScreen> createState() => _MacosMenuScreenState();
}

class _MacosMenuScreenState extends State<MacosMenuScreen> {
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
    return CupertinoTabView(
      builder: (context) => MacosScaffold(
        toolBar: const ToolBar(
          title: Text('Menu'),
        ),
        children: [
          ContentArea(
            minWidth: 350,
            builder: (_, controller) => FutureBuilder(
              future: _fetchSmoothieData(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    snapshot.data != null) {
                  return const Center(
                    child: ProgressCircle(value: null),
                  );
                }
                if (snapshot.hasError) {
                  debugPrint(snapshot.error.toString());
                }

                if (snapshot.data == null) {
                  return const Center(
                    child: ProgressCircle(value: null),
                  );
                }
                final smoothie = smoothieFromJson(snapshot.data.toString());
                return snapshot.hasData
                    ? GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisExtent: 300,
                                mainAxisSpacing: 50,
                                crossAxisSpacing: 20),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        controller: ScrollController(),
                        itemCount: smoothie.length,
                        itemBuilder: (BuildContext context, int index) {
                          var smoothieItem = smoothie[index];
                          var ingredients = [
                            for (final i in smoothieItem.ingredients)
                              i.localizedFoodItemNames.en
                          ].join(', ');

                          return MacCard(
                            cardImage: smoothieItem.imagePath,
                            cardTitle: smoothieItem.smoothieName,
                            cardSubtitle: ingredients,
                            cardSubtitle2: '${smoothieItem.calories} Calories',
                            onPressed: () => Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => DrinkDetails(
                                        smoothie: smoothieItem,
                                      )),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          'There are no smoothies to show',
                          softWrap: true,
                          style: MacosTheme.of(context).typography.body,
                        ),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}

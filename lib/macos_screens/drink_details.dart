import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter_fruta/model/smoothie_model.dart';
import 'package:flutter_fruta/widgets/ingredient_widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:macos_ui/macos_ui.dart';

var favBox = Hive.box('frutaFavourites');

class DrinkDetails extends StatefulWidget {
  const DrinkDetails({super.key, required this.smoothie});

  final Smoothie smoothie;

  @override
  State<DrinkDetails> createState() => _DrinkDetailsState();
}

class _DrinkDetailsState extends State<DrinkDetails> {
  @override
  void initState() {
    super.initState();
    _fetchIngredientsData();
  }

  Future<String> _fetchIngredientsData() async {
    return await DefaultAssetBundle.of(context)
        .loadString('assets/smoothie_data.json');
  }

  @override
  Widget build(BuildContext context) {
    var cardKey = GlobalKey<FlipCardState>();
    return FutureBuilder(
      future: _fetchIngredientsData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final smoothieData = smoothieFromJson(snapshot.data.toString());
        var smoothieDetails = smoothieData
            .where((element) =>
                element.smoothieName == widget.smoothie.smoothieName)
            .single;

        if (snapshot.data == null) {
          return const Center(
            child: ProgressCircle(),
          );
        }
        return snapshot.hasData
            ? MacosScaffold(
                toolBar: ToolBar(
                  title: Text(widget.smoothie.smoothieName),
                  titleWidth: 250,
                  actions: [
                    ToolBarIconButton(
                      label: 'Favourite',
                      icon: favBox.containsKey(widget.smoothie.smoothieName)
                          ? Icon(
                              CupertinoIcons.heart_solid,
                              color: MacosTheme.of(context).primaryColor,
                              size: 25,
                            )
                          : Icon(
                              CupertinoIcons.heart,
                              color: MacosTheme.of(context).primaryColor,
                              size: 25,
                            ),
                      showLabel: false,
                      onPressed: () {
                        setState(() {
                          if (favBox
                              .containsKey(widget.smoothie.smoothieName)) {
                            favBox.delete(widget.smoothie.smoothieName);
                          } else {
                            favBox.put(widget.smoothie.smoothieName, {
                              'name': widget.smoothie.smoothieName,
                              'image': widget.smoothie.imagePath,
                              'calories': widget.smoothie.calories,
                              'desc': widget.smoothie.description,
                              'ingredients': [
                                for (var item in widget.smoothie.ingredients)
                                  item.localizedFoodItemNames.en
                              ].join(', '),
                            });
                          }
                        });
                      },
                    ),
                  ],
                ),
                children: [
                    ContentArea(
                      builder: (context, controller) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    height: 200,
                                    width: double.infinity,
                                    child: PhysicalModel(
                                      color: MacosTheme.of(context)
                                          .canvasColor
                                          .withOpacity(0.7),
                                      elevation: 4,
                                      borderRadius: BorderRadius.circular(20),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10,
                                                  top: 20,
                                                  bottom: 20),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      widget
                                                          .smoothie.description,
                                                      style: MacosTheme.of(
                                                              context)
                                                          .typography
                                                          .title1
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                    Text(
                                                      '${widget.smoothie.calories} Calories',
                                                      style: MacosTheme.of(
                                                              context)
                                                          .typography
                                                          .title2
                                                          .copyWith(
                                                              color: MacosColors
                                                                  .systemGrayColor),
                                                    )
                                                  ]),
                                            ),
                                          ),
                                          const SizedBox(width: 50),
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(20),
                                                    bottomRight:
                                                        Radius.circular(20)),
                                            child: SizedBox(
                                              width: 200,
                                              child: Image.asset(
                                                  widget.smoothie.imagePath,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text(
                                    'Ingredients',
                                    style: MacosTheme.of(context)
                                        .typography
                                        .largeTitle
                                        .copyWith(
                                          color: MacosColors.systemGrayColor,
                                        ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 200,
                                  child: ListView.separated(
                                    itemCount:
                                        smoothieDetails.ingredients.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var singleIngredient =
                                          smoothieDetails.ingredients[index];
                                      return GestureDetector(
                                          child: IngredientGridItem(
                                              singleIngredient:
                                                  singleIngredient),
                                          onTap: () => showCupertinoDialog(
                                                context: context,
                                                useRootNavigator: false,
                                                builder: (_) =>
                                                    CupertinoPopupSurface(
                                                  isSurfacePainted: true,
                                                  child: Center(
                                                    child: SizedBox(
                                                      height: 500,
                                                      width: 400,
                                                      child: FlipCard(
                                                        key: cardKey,
                                                        flipOnTouch: false,
                                                        front: FrontIngredientCard(
                                                            singleIngredient:
                                                                singleIngredient,
                                                            cardKey: cardKey),
                                                        back: BackIngredientCard(
                                                            singleIngredient:
                                                                singleIngredient,
                                                            cardKey: cardKey),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ));
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            const SizedBox(width: 15),
                                  ),
                                ),
                                const Spacer(),
                                // TODO Will need to add a stack here
                                Center(
                                  child: SizedBox(
                                    width: 300,
                                    child: PushButton(
                                        color:
                                            MacosTheme.of(context).brightness ==
                                                    Brightness.dark
                                                ? MacosColors.white
                                                : MacosColors.black,
                                        controlSize: ControlSize.large,
                                        onPressed: () {},
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text('Pay with'),
                                              MacosIcon(
                                                Icons.apple,
                                                color: MacosTheme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? MacosColors.black
                                                    : MacosColors.white,
                                              ),
                                              const Text('Pay'),
                                            ])),
                                  ),
                                )
                              ]),
                        );
                      },
                    )
                  ])
            : MacosScaffold(
                children: [
                  ContentArea(
                      builder: (_, __) => Center(
                            child: Text(
                                'There are no details about ${widget.smoothie.smoothieName}',
                                softWrap: true,
                                style:
                                    MacosTheme.of(context).typography.headline),
                          ))
                ],
              );
      },
    );
  }
}

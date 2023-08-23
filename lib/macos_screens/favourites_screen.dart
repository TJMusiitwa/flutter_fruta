import 'package:flutter/cupertino.dart';
import 'package:flutter_fruta/widgets/mac_card.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:macos_ui/macos_ui.dart';

class MacosFavouritesScreen extends StatelessWidget {
  const MacosFavouritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: ToolBar(
        title: const Text('Favourites'),
        actions: [
          ToolBarIconButton(
              label: 'Share',
              icon: MacosIcon(CupertinoIcons.share,
                  color: MacosTheme.of(context).primaryColor),
              showLabel: true),
          ToolBarIconButton(
              label: 'Delete',
              icon: MacosIcon(CupertinoIcons.delete,
                  color: MacosTheme.of(context).primaryColor),
              showLabel: true,
              onPressed: () {
                showMacosAlertDialog(
                    context: context,
                    builder: (_) {
                      return MacosAlertDialog(
                        appIcon: const MacosIcon(
                          CupertinoIcons.delete,
                          size: 56,
                          color: MacosColors.systemRedColor,
                        ),
                        title: const Text('Clear Favourites'),
                        message: const Text(
                            'Are you sure you want to clear your favourites?\nThis action cannot be undone.'),
                        primaryButton: PushButton(
                            controlSize: ControlSize.large,
                            color: MacosColors.systemRedColor,
                            onPressed: () {
                              Hive.box('frutaFavourites').clear();
                            },
                            child: const Text('Delete')),
                        secondaryButton: PushButton(
                          controlSize: ControlSize.large,
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        horizontalActions: false,
                      );
                    });
              }),
          const ToolBarSpacer()
        ],
      ),
      children: [
        ContentArea(
          builder: (_, controller) => ValueListenableBuilder(
            valueListenable: Hive.box('frutaFavourites').listenable(),
            builder: (BuildContext context, dynamic box, Widget? child) {
              if (box.isEmpty) {
                return Align(
                  alignment: Alignment.center,
                  child: Text(
                    '❤️ some smoothies to see them appear here',
                    style: MacosTheme.of(context).typography.subheadline,
                  ),
                );
              }
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisExtent: 300,
                    mainAxisSpacing: 50,
                    crossAxisSpacing: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                controller: controller,
                itemCount: box.length,
                itemBuilder: (BuildContext context, int index) {
                  var favItem = box.values.toList();
                  return MacCard(
                    cardImage: favItem[index]['image'],
                    cardTitle: favItem[index]['name'],
                    cardSubtitle: '${favItem[index]['calories']} calories',
                    cardSubtitle2: favItem[index]['ingredients'].toString(),
                    onPressed: () {
                      showMacosSheet(
                          context: context,
                          barrierDismissible: true,
                          builder: (_) {
                            return MacosSheet(
                                child: Column(children: [
                              SizedBox(
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height / 1.8,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                  child: Image.asset(
                                    favItem[index]['image'],
                                    // color: CupertinoColors.systemGrey2,
                                    // colorBlendMode: BlendMode.darken,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          favItem[index]['name'],
                                          style: MacosTheme.of(context)
                                              .typography
                                              .largeTitle,
                                        ),
                                        Text(
                                          '${favItem[index]['calories']} Calories',
                                          style: MacosTheme.of(context)
                                              .typography
                                              .title3
                                              .copyWith(
                                                  color: MacosTheme.of(context)
                                                      .primaryColor),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                        'Ingredients: ${favItem[index]['ingredients']}',
                                        softWrap: true,
                                        textAlign: TextAlign.start,
                                        style: MacosTheme.of(context)
                                            .typography
                                            .title2),
                                    const SizedBox(height: 20),
                                    Text(favItem[index]['desc'],
                                        softWrap: true,
                                        textAlign: TextAlign.start,
                                        style: MacosTheme.of(context)
                                            .typography
                                            .title2),
                                  ],
                                ),
                              ),
                            ]));
                          });
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

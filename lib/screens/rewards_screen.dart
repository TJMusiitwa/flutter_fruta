import 'dart:io';

import 'package:animated_background/animated_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_fruta/widgets/rewardCircles.dart';
import 'package:macos_ui/macos_ui.dart';

class RewardsScreen extends StatefulWidget {
  @override
  _RewardsScreenState createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    if (Platform.isMacOS) {
      return MacosScaffold(
        backgroundColor: MacosTheme.of(context).brightness == Brightness.dark
            ? MacosColors.systemIndigoColor
            : const Color.fromRGBO(177, 159, 219, 0.4),
        children: [
          ContentArea(
            builder: (_, __) => AnimatedBackground(
              vsync: this,
              behaviour: RandomParticleBehaviour(
                options: const ParticleOptions(
                  particleCount: 10,
                  spawnMinSpeed: 4,
                  spawnMaxSpeed: 5,
                  spawnMaxRadius: 100,
                  maxOpacity: 0.40,
                  spawnOpacity: 0.3,
                  baseColor: Color.fromRGBO(177, 159, 219, 1),
                ),
              ),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PhysicalModel(
                        color: CupertinoColors.lightBackgroundGray,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        shadowColor: CupertinoColors.black,
                        elevation: 2,
                        child: SizedBox(
                          //height: 200,
                          width: 350,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Rewards Card',
                                  style: CupertinoTheme.of(context)
                                      .textTheme
                                      .dateTimePickerTextStyle
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 65,
                                  width: double.maxFinite,
                                  child: RewardCircles(),
                                ),
                                SizedBox(
                                  height: 65,
                                  child: RewardCircles(),
                                )
                              ],
                            ),
                          ),
                        )),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10.0, right: 10, top: 5),
                      child: Text(
                        'You are 10 points away from a free \nsmoothie!',
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .textStyle
                            .copyWith(fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      );
    }
    return CupertinoPageScaffold(
      backgroundColor: CupertinoTheme.of(context).brightness == Brightness.dark
          ? CupertinoColors.systemIndigo
          : const Color.fromRGBO(177, 159, 219, 0.4),
      child: AnimatedBackground(
        vsync: this,
        behaviour: RandomParticleBehaviour(
          options: const ParticleOptions(
            particleCount: 10,
            spawnMinSpeed: 4,
            spawnMaxSpeed: 5,
            spawnMaxRadius: 100,
            maxOpacity: 0.40,
            spawnOpacity: 0.3,
            baseColor: Color.fromRGBO(177, 159, 219, 1),
          ),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PhysicalModel(
                  color: CupertinoColors.lightBackgroundGray,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  shadowColor: CupertinoColors.black,
                  elevation: 2,
                  child: SizedBox(
                    //height: 200,
                    width: 350,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Rewards Card',
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .dateTimePickerTextStyle
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 65,
                            width: double.maxFinite,
                            child: RewardCircles(),
                          ),
                          SizedBox(
                            height: 65,
                            child: RewardCircles(),
                          )
                        ],
                      ),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10, top: 5),
                child: Text(
                  'You are 10 points away from a free \nsmoothie!',
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .textStyle
                      .copyWith(fontSize: 18),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

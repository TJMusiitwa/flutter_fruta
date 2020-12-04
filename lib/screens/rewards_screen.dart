import 'package:animated_background/animated_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_fruta/widgets/rewardCircles.dart';

class RewardsScreen extends StatefulWidget {
  @override
  _RewardsScreenState createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoTheme.of(context).brightness == Brightness.dark
          ? CupertinoColors.systemIndigo
          : Color.fromRGBO(177, 159, 219, 0.4),
      child: AnimatedBackground(
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
                  child: Container(
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
                            child: RewardCircles(),
                            height: 65,
                            width: double.maxFinite,
                          ),
                          SizedBox(
                            child: RewardCircles(),
                            height: 65,
                          )
                        ],
                      ),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10, top: 5),
                child: Text(
                  "You are 10 points away from a free \nsmoothie!",
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
        vsync: this,
        behaviour: RandomParticleBehaviour(
          options: ParticleOptions(
            particleCount: 10,
            spawnMinSpeed: 4,
            spawnMaxSpeed: 5,
            spawnMaxRadius: 100,
            maxOpacity: 0.40,
            spawnOpacity: 0.3,
            baseColor: Color.fromRGBO(177, 159, 219, 1),
          ),
        ),
      ),
    );
  }
}

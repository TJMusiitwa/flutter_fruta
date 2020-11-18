import 'package:animated_background/animated_background.dart';
import 'package:flutter/cupertino.dart';

class RewardsScreen extends StatefulWidget {
  @override
  _RewardsScreenState createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemIndigo,
      child: AnimatedBackground(
        child: Center(
          child: PhysicalModel(
              color: CupertinoColors.lightBackgroundGray,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              shadowColor: CupertinoColors.black,
              elevation: 2,
              child: Container(
                height: 180,
                width: 350,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Rewards Card',
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .dateTimePickerTextStyle
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              )),
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
            baseColor: Color.fromRGBO(170, 157, 219, 1),
          ),
        ),
      ),
    );
  }
}

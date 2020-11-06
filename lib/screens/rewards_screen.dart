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
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            shadowColor: CupertinoColors.black,
            elevation: 2,
            child: Text('Rewards Card'),
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
            baseColor: Color.fromRGBO(170, 157, 219, 1),
          ),
        ),
      ),
    );
  }
}

import 'package:animated_background/animated_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_fruta/widgets/rewardCircles.dart';
import 'package:macos_ui/macos_ui.dart';

class MacosRewardsScreen extends StatefulWidget {
  const MacosRewardsScreen({super.key});

  @override
  State<MacosRewardsScreen> createState() => _MacosRewardsScreenState();
}

class _MacosRewardsScreenState extends State<MacosRewardsScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: const ToolBar(
        title: Text('Rewards'),
      ),
      children: [
        ContentArea(
          builder: (_, __) => AnimatedBackground(
            vsync: this,
            behaviour: RandomParticleBehaviour(
              options: const ParticleOptions(
                particleCount: 15,
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
                      color: MacosTheme.brightnessOf(context).isDark
                          ? MacosTheme.of(context).canvasColor
                          : MacosTheme.of(context).canvasColor,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      shadowColor: MacosColors.black,
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
                                style: MacosTheme.of(context).typography.title3,
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
                      style: MacosTheme.of(context).typography.headline,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

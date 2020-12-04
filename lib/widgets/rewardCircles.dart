import 'package:flutter/cupertino.dart';

class RewardCircles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    for (var x = 0; x < 5; x++) {
      widgets.add(
        Container(
          height: 48.0,
          width: 55.0,
          margin: EdgeInsets.all(6.0),
          decoration: BoxDecoration(
              //borderRadius: BorderRadius.circular(10.0),
              color: CupertinoColors.systemIndigo.withOpacity(0.5),
              shape: BoxShape.circle),
        ),
      );
    }
    return Container(
        height: 10.0,
        child: ListView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.antiAlias,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(2.0),
            children: widgets));
  }
}

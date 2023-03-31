import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';

class FrostyBackground extends StatelessWidget {
  final Color? color;
  final double intensity;
  final Widget child;

  const FrostyBackground(
      {Key? key, this.color, this.intensity = 25, required this.child})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: intensity, sigmaY: intensity),
        child: DecoratedBox(
          decoration: BoxDecoration(color: color),
          child: child,
        ),
      ),
    );
  }
}

class PressableCard extends StatefulWidget {
  final VoidCallback onPressed;

  final Widget child;

  final BorderRadius borderRadius;

  final double upElevation;

  final double downElevation;

  final Color shadowColor;

  final Duration duration;

  const PressableCard(
      {Key? key,
      required this.onPressed,
      this.borderRadius = const BorderRadius.all(Radius.circular(10)),
      this.upElevation = 2,
      this.downElevation = 0,
      this.shadowColor = MacosColors.alternatingContentBackgroundColor,
      this.duration = const Duration(milliseconds: 100),
      required this.child})
      : super(key: key);
  @override
  State<PressableCard> createState() => _PressableCardState();
}

class _PressableCardState extends State<PressableCard> {
  bool cardIsDown = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          cardIsDown = false;
        });
        // ignore: unnecessary_null_comparison
        if (widget.onPressed != null) {
          widget.onPressed();
        }
      },
      onTapDown: (details) => setState(() => cardIsDown = true),
      onTapCancel: () => setState(() => cardIsDown = false),
      child: AnimatedPhysicalModel(
        elevation: cardIsDown ? widget.downElevation : widget.upElevation,
        borderRadius: widget.borderRadius,
        shape: BoxShape.rectangle,
        shadowColor: widget.shadowColor,
        duration: widget.duration,
        color: MacosColors.systemGrayColor,
        child: ClipRRect(
          borderRadius: widget.borderRadius,
          child: widget.child,
        ),
      ),
    );
  }
}

class MacCard extends StatelessWidget {
  const MacCard({
    required this.cardImage,
    required this.cardTitle,
    this.cardSubtitle,
    this.cardSubtitle2,
    this.enableCornerIcon = false,
    this.onPressed,
    Key? key,
  }) : super(key: key);
  final String cardImage;
  final String cardTitle;
  final String? cardSubtitle;
  final String? cardSubtitle2;

  final bool? enableCornerIcon;

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return PressableCard(
      onPressed: onPressed!,
      child: Stack(
        children: [
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Image.asset(cardImage, fit: BoxFit.cover),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: FrostyBackground(
              color: const Color(0x90ffffff),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cardTitle,
                      style: MacosTheme.of(context).typography.title1,
                    ),
                    const SizedBox(height: 5),
                    Text(cardSubtitle!,
                        style: MacosTheme.of(context).typography.headline),
                    const SizedBox(height: 7.0),
                    Text(
                      cardSubtitle2!,
                      style: MacosTheme.of(context).typography.body.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

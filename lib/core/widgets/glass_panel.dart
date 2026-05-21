import 'dart:ui';
import 'package:flutter/material.dart';

class GlassPanel extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;

  const GlassPanel({
    super.key,
    required this.child,
    this.width = double.infinity,
    this.height = double.infinity,
    this.padding = const EdgeInsets.all(24.0),
    this.borderRadius = const BorderRadius.all(Radius.circular(24.0)),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: borderRadius,
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

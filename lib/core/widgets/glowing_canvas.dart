import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GlowingCanvas extends StatelessWidget {
  final Widget child;

  const GlowingCanvas({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.onyxBlack,
      body: Stack(
        children: [
          // Top Left Glow
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.electricIndigo.withOpacity(0.15),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 1.0],
                ),
              ),
            ),
          ),
          // Bottom Right Glow
          Positioned(
            bottom: -150,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.electricIndigo.withOpacity(0.1),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 1.0],
                ),
              ),
            ),
          ),
          // Main Content
          SafeArea(
            child: child,
          ),
        ],
      ),
    );
  }
}

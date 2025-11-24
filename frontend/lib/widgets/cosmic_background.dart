import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../config/constants.dart';

class CosmicBackground extends StatefulWidget {
  final Widget child;
  
  const CosmicBackground({super.key, required this.child});

  @override
  State<CosmicBackground> createState() => _CosmicBackgroundState();
}

class _CosmicBackgroundState extends State<CosmicBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.background,
                Color(0xFF1A0D2E),
                AppColors.background,
              ],
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: StarsPainter(_controller.value),
              child: Container(),
            );
          },
        ),
        widget.child,
      ],
    );
  }
}

class StarsPainter extends CustomPainter {
  final double animation;
  final math.Random random = math.Random(42);

  StarsPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 100; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final opacity = (math.sin(animation * 2 * math.pi + i) + 1) / 2;
      
      paint.color = Colors.white.withOpacity(opacity * 0.6);
      canvas.drawCircle(
        Offset(x, y),
        random.nextDouble() * 1.5 + 0.5,
        paint,
      );
    }

    final glowPaint = Paint()
      ..color = AppColors.primary.withOpacity(0.1)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);

    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.3),
      100,
      glowPaint,
    );

    glowPaint.color = AppColors.secondary.withOpacity(0.1);
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.7),
      120,
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

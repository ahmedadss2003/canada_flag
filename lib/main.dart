import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(
            'Animated Canadian Flag',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
          child: AnimatedFlag(),
        ),
      ),
    );
  }
}

class AnimatedFlag extends StatefulWidget {
  @override
  _AnimatedFlagState createState() => _AnimatedFlagState();
}

class _AnimatedFlagState extends State<AnimatedFlag>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _stripeAnimation;
  late Animation<double> _centerAnimation;
  late Animation<double> _leafAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 6),
      vsync: this,
    );

    _stripeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.0,
          0.33,
          curve: Curves.easeInOut,
        ),
      ),
    );

    _centerAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.33,
          0.66,
          curve: Curves.easeInOut,
        ),
      ),
    );

    _leafAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.66,
          0.9,
          curve: Curves.easeInOut,
        ),
      ),
    );

    _textAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.9,
          1.0,
          curve: Curves.easeInOut,
        ),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomPaint(
          size: Size(300, 200),
          painter: CanadianFlagPainter(
            stripeAnimation: _stripeAnimation,
            centerAnimation: _centerAnimation,
            leafAnimation: _leafAnimation,
          ),
        ),
        SizedBox(height: 20),
        FadeTransition(
          opacity: _textAnimation,
          child: Text(
            'Canada Flag',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class CanadianFlagPainter extends CustomPainter {
  final Animation<double> stripeAnimation;
  final Animation<double> centerAnimation;
  final Animation<double> leafAnimation;

  CanadianFlagPainter({
    required this.stripeAnimation,
    required this.centerAnimation,
    required this.leafAnimation,
  }) : super(
            repaint: Listenable.merge(
                [stripeAnimation, centerAnimation, leafAnimation]));

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Draw the red stripes with animation
    paint.color = Colors.red;
    canvas.drawRect(
        Rect.fromLTWH(
            0, 0, (size.width / 4) * stripeAnimation.value, size.height),
        paint);
    canvas.drawRect(
        Rect.fromLTWH(3 * size.width / 4, 0,
            (size.width / 4) * stripeAnimation.value, size.height),
        paint);

    // Draw the white center with animation
    paint.color = Colors.white;
    canvas.drawRect(
        Rect.fromLTWH(size.width / 4, 0,
            (size.width / 2) * centerAnimation.value, size.height),
        paint);

    // Draw the maple leaf with animation
    if (leafAnimation.value > 0) {
      paint.color = Colors.red;
      final path = Path();
      path.moveTo(size.width / 2, size.height / 4);
      path.lineTo(size.width / 2 - 10 * leafAnimation.value,
          size.height / 2 - 10 * leafAnimation.value);
      path.lineTo(size.width / 2 - 20 * leafAnimation.value,
          size.height / 2 - 30 * leafAnimation.value);
      path.lineTo(size.width / 2 - 30 * leafAnimation.value,
          size.height / 2 - 10 * leafAnimation.value);
      path.lineTo(size.width / 2 - 40 * leafAnimation.value, size.height / 2);
      path.lineTo(size.width / 2 - 30 * leafAnimation.value,
          size.height / 2 + 10 * leafAnimation.value);
      path.lineTo(size.width / 2 - 40 * leafAnimation.value,
          size.height / 2 + 30 * leafAnimation.value);
      path.lineTo(size.width / 2 - 20 * leafAnimation.value,
          size.height / 2 + 20 * leafAnimation.value);
      path.lineTo(size.width / 2 - 10 * leafAnimation.value,
          size.height / 2 + 40 * leafAnimation.value);
      path.lineTo(size.width / 2, size.height / 2 + 20 * leafAnimation.value);
      path.lineTo(size.width / 2 + 10 * leafAnimation.value,
          size.height / 2 + 40 * leafAnimation.value);
      path.lineTo(size.width / 2 + 20 * leafAnimation.value,
          size.height / 2 + 20 * leafAnimation.value);
      path.lineTo(size.width / 2 + 40 * leafAnimation.value,
          size.height / 2 + 30 * leafAnimation.value);
      path.lineTo(size.width / 2 + 30 * leafAnimation.value,
          size.height / 2 + 10 * leafAnimation.value);
      path.lineTo(size.width / 2 + 40 * leafAnimation.value, size.height / 2);
      path.lineTo(size.width / 2 + 30 * leafAnimation.value,
          size.height / 2 - 10 * leafAnimation.value);
      path.lineTo(size.width / 2 + 20 * leafAnimation.value,
          size.height / 2 - 30 * leafAnimation.value);
      path.lineTo(size.width / 2 + 10 * leafAnimation.value,
          size.height / 2 - 10 * leafAnimation.value);
      path.close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

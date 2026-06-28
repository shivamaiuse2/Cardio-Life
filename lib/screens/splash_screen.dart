import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF8B0000),
              Color(0xFFB71C1C),
              Color(0xFFC62828),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Decorative circles
              Positioned(
                top: -40,
                right: -40,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: (0.04)),
                  ),
                ),
              ),
              Positioned(
                top: 60,
                right: 20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: (0.06)),
                  ),
                ),
              ),
              // Main content
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: (0.2)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.favorite_rounded,
                              color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 10),
                        const Text('CardioLife',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            )),
                        const Spacer(),
                        Text('HEART CARE',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: (0.6)),
                              fontSize: 10,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w500,
                            )),
                      ],
                    ),
                  ),
                  Expanded(
                    child: FadeTransition(
                      opacity: _fadeIn,
                      child: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Pulsing ring
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.9, end: 1.05),
                              duration: const Duration(seconds: 2),
                              curve: Curves.easeInOut,
                              builder: (context, scale, child) {
                                return Transform.scale(
                                  scale: scale,
                                  child: Container(
                                    width: 260,
                                    height: 260,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withValues(alpha: (0.05)),
                                    ),
                                  ),
                                );
                              },
                            ),
                            // Heart icon large
                            Container(
                              width: 220,
                              height: 220,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: (0.08)),
                              ),
                              child: const Icon(
                                Icons.favorite_rounded,
                                size: 120,
                                color: Colors.white,
                              ),
                            ),
                            // ECG line overlay
                            Positioned(
                              bottom: 60,
                              left: 20,
                              right: 20,
                              child: CustomPaint(
                                painter: ECGPainter(),
                                size: const Size(double.infinity, 40),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SlideTransition(
                    position: _slideUp,
                    child: FadeTransition(
                      opacity: _fadeIn,
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Your Heart\nDeserves the',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                            ),
                            const Text(
                              'Best Care',
                              style: TextStyle(
                                color: Color(0xFFFFCDD2),
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Advanced care for heart health.\nEarly diagnosis. Better life.',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: (0.75)),
                                fontSize: 15,
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 40),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => Navigator.pushReplacementNamed(
                                        context, '/home'),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 18),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Get Started',
                                            style: TextStyle(
                                              color: AppColors.primary,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Icon(Icons.arrow_forward_rounded,
                                              color: AppColors.primary, size: 20),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Container(
                                  width: 58,
                                  height: 58,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: (0.2)),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                        color: Colors.white.withValues(alpha: (0.4)), width: 1.5),
                                  ),
                                  child: const Icon(Icons.favorite_rounded,
                                      color: Colors.white, size: 26),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ECG line painter
class ECGPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: (0.4))
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final w = size.width;
    final mid = size.height / 2;

    path.moveTo(0, mid);
    path.lineTo(w * 0.15, mid);
    path.lineTo(w * 0.2, mid - 8);
    path.lineTo(w * 0.25, mid + 15);
    path.lineTo(w * 0.3, mid - 30);
    path.lineTo(w * 0.35, mid + 10);
    path.lineTo(w * 0.4, mid - 5);
    path.lineTo(w * 0.45, mid);
    path.lineTo(w * 0.6, mid);
    path.lineTo(w * 0.65, mid - 8);
    path.lineTo(w * 0.7, mid + 15);
    path.lineTo(w * 0.75, mid - 30);
    path.lineTo(w * 0.8, mid + 10);
    path.lineTo(w * 0.85, mid - 5);
    path.lineTo(w * 0.9, mid);
    path.lineTo(w, mid);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
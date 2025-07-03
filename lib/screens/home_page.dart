import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController fadeController;
  late AnimationController slideController;
  late AnimationController scaleController;
  late AnimationController buttonSlideController;

  late Animation<double> fadeAnim;
  late Animation<double> slideAnim;
  late Animation<double> scaleAnim;
  late Animation<double> buttonSlideAnim;

  @override
  void initState() {
    super.initState();

    fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    buttonSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    fadeAnim = Tween<double>(begin: 0, end: 1).animate(fadeController);
    slideAnim = Tween<double>(begin: 50, end: 0).animate(slideController);
    scaleAnim = Tween<double>(begin: 0.8, end: 1).animate(scaleController);
    buttonSlideAnim = Tween<double>(
      begin: 100,
      end: 0,
    ).animate(buttonSlideController);

    fadeController.forward();
    slideController.forward();
    scaleController.forward();
    buttonSlideController.forward();
  }

  @override
  void dispose() {
    fadeController.dispose();
    slideController.dispose();
    scaleController.dispose();
    buttonSlideController.dispose();
    super.dispose();
  }

  void animatePress(VoidCallback callback) {
    scaleController.reverse().then((_) {
      scaleController.forward().then((_) {
        callback();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF2196F3), // Blue 500
                  Color(0xFF90CAF9), // Light Blue 200
                  Color(0xFFFFFFFF), // White
                ],
                stops: [0, 0.6, 1],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Stack(
              children: [
                // Decorative Circles
                Positioned(
                  top: -50,
                  right: -50,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -100,
                  left: -80,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: fadeController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: fadeAnim.value,
                      child: Transform.translate(
                        offset: Offset(0, slideAnim.value),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo Section
                      AnimatedBuilder(
                        animation: scaleController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: scaleAnim.value,
                            child: child,
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 20),
                          alignment: Alignment.center,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.8),
                                    width: 4,
                                  ),
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/farm-logo.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Title and Subtitle
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text(
                              'Farm AI',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 1.5,
                                shadows: [
                                  Shadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.3),
                                    offset: Offset(0, 2),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 80,
                              height: 4,
                              margin: const EdgeInsets.only(top: 8, bottom: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromRGBO(255, 255, 255, 0.9),
                                  fontWeight: FontWeight.w400,
                                  height: 1.4,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Revolutionizing agriculture with\n',
                                  ),
                                  TextSpan(
                                    text: 'smart technology',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFFFFFFF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Features Section
                      Container(
                        margin: const EdgeInsets.only(top: 40),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildFeatureItem('🌱', 'Smart Crops'),
                            _buildFeatureItem('📊', 'Analytics'),
                            _buildFeatureItem('🤖', 'AI Insights'),
                          ],
                        ),
                      ),
                      // Buttons Section
                      AnimatedBuilder(
                        animation: buttonSlideController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, buttonSlideAnim.value),
                            child: child,
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          margin: const EdgeInsets.only(top: 40),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () =>  {
                                  Navigator.pushNamed(context, '/login')
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade800,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.5),
                                      width: 2,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
                                  margin: const EdgeInsets.only(bottom: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        'Sign In',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        '→',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>  {
                                  Navigator.pushNamed(context, '/signup')
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade800,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.5),
                                      width: 2,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        'Create Account',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        '→',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Bottom Tagline
                      Opacity(
                        opacity: fadeAnim.value,
                        child: Container(
                          margin: const EdgeInsets.only(top: 20),
                          alignment: Alignment.center,
                          child: const Text(
                            'Join thousands of farmers growing smarter',
                            style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 0.7),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String emoji, String text) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

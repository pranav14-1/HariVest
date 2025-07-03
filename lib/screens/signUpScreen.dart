import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpScreen extends StatefulWidget {
  final Function(String routeName) navigate;

  // Pass a navigation callback to mimic React Navigation
  const SignUpScreen({Key? key, required this.navigate}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late AnimationController _buttonScaleController;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();

    _buttonScaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.95,
      upperBound: 1.0,
    );

    _buttonScaleAnimation =
        CurvedAnimation(parent: _buttonScaleController, curve: Curves.easeInOut);
    _buttonScaleController.value = 1.0; // start at normal scale
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _buttonScaleController.dispose();
    super.dispose();
  }

  void _animatePress(VoidCallback callback) async {
    await _buttonScaleController.reverse();
    await _buttonScaleController.forward();
    callback();
  }

  void _handleSignUp() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      // Mimic navigation reset to 'MainAppTabs'
      widget.navigate('MainAppTabs');
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Incomplete Form'),
          content: const Text('Please fill all fields (Name, Email, and Password).'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Status bar styling
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Linear Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF2DD4BF),
                  Color(0xFF059669),
                  Color(0xFF065F46),
                ],
                stops: [0, 0.6, 1],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

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

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0d6e5b),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 10),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(0, 2),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 8),

                      // Underline
                      Container(
                        width: 60,
                        height: 3,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Subtitle
                      Text(
                        'Join FarmAI to start your smart farming journey',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.85),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 24),

                      // Input Group
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildInputField(
                            controller: _nameController,
                            hintText: 'Full Name',
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(height: 16),
                          _buildInputField(
                            controller: _emailController,
                            hintText: 'Email Address',
                            keyboardType: TextInputType.emailAddress,
                            autoCorrect: false,
                            autoCapitalize: false,
                          ),
                          const SizedBox(height: 16),
                          _buildInputField(
                            controller: _passwordController,
                            hintText: 'Password',
                            obscureText: true,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Animated Button
                      ScaleTransition(
                        scale: _buttonScaleAnimation,
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF059669),
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              shadowColor: const Color(0xFF10B981),
                              elevation: 15,
                            ),
                            onPressed: () =>
                                _animatePress(_handleSignUp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '→',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Link to Sign In
                      GestureDetector(
                        onTap: () => widget.navigate('SignIn'),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white.withOpacity(0.75),
                            ),
                            children: [
                              TextSpan(
                                text: 'Sign In',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFFBBF24),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    bool autoCorrect = true,
    bool autoCapitalize = true,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      autocorrect: autoCorrect,
      autofocus: false,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      cursorColor: const Color(0xFFFBBF24),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.15),
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.4), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.4), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFBBF24), width: 2),
        ),
      ),
      textCapitalization:
          autoCapitalize ? TextCapitalization.sentences : TextCapitalization.none,
    );
  }
}

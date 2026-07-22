import 'package:flutter/material.dart';
import 'package:wrapit/theme/theme.dart';
import 'package:wrapit/widgets/glassmorphic_container.dart';
import 'package:wrapit/widgets/premium_button.dart';
import 'package:wrapit/screens/main_shell.dart';
import 'package:wrapit/state/app_state.dart';
import 'package:wrapit/animations/page_transitions.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  bool _isLogin = true;
  final _nameController = TextEditingController(text: 'Sarah');
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  late AnimationController _animController;
  late Animation<double> _cardSlide;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _cardSlide = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleMode() {
    setState(() => _isLogin = !_isLogin);
    _animController.reset();
    _animController.forward();
  }

  void _submit() {
    // Grab the AppState that was provided at the root in main.dart.
    final appState = AppStateProvider.of(context);
    final name = _nameController.text.trim().isEmpty
        ? 'Friend'
        : _nameController.text.trim();
    appState.login(name);
    Navigator.of(context).pushReplacement(
      WrapItPageTransitions.fadeScaleTransition(page: MainShell(appState: appState)),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: WrapItGradients.luxuryPink),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: AnimatedBuilder(
              animation: _animController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _cardSlide.value),
                  child: Opacity(
                    opacity: _animController.value,
                    child: child,
                  ),
                );
              },
              child: Column(
                children: [
                  const SizedBox(height: 48),

                  // Header
                  const Text('🎁', style: TextStyle(fontSize: 56)),
                  const SizedBox(height: 16),
                  Text(
                    _isLogin ? 'Welcome Back' : 'Create Account',
                    style: WrapItText.displayMedium()
                        .copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isLogin
                        ? 'Sign in to continue gifting'
                        : 'Join the premium gifting experience',
                    style: WrapItText.body().copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Auth card
                  GlassmorphicContainer(
                    blur: 25,
                    backgroundColor: Colors.white.withValues(alpha: 0.85),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        if (!_isLogin) ...[
                          _buildField(
                            controller: _nameController,
                            hint: 'Full Name',
                            icon: Icons.person_outline_rounded,
                          ),
                          const SizedBox(height: 16),
                        ],

                        _buildField(
                          controller: _emailController,
                          hint: 'Email Address',
                          icon: Icons.email_outlined,
                          type: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),

                        _buildField(
                          controller: _passwordController,
                          hint: 'Password',
                          icon: Icons.lock_outline_rounded,
                          obscure: _obscurePassword,
                          suffix: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: WrapItColors.textLight,
                              size: 20,
                            ),
                            onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                          ),
                        ),

                        if (_isLogin) ...[
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {},
                              child: Text(
                                'Forgot Password?',
                                style: WrapItText.bodySmall().copyWith(
                                  color: WrapItColors.accent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 24),

                        PremiumButton(
                          label: _isLogin ? 'Sign In' : 'Create Account',
                          width: double.infinity,
                          onPressed: _submit,
                        ),

                        const SizedBox(height: 24),

                        // Divider
                        Row(
                          children: [
                            Expanded(
                                child: Divider(
                                    color: WrapItColors.divider, height: 1)),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text('or continue with',
                                  style: WrapItText.bodySmall()),
                            ),
                            Expanded(
                                child: Divider(
                                    color: WrapItColors.divider, height: 1)),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Social buttons — both just call the same fake submit.
                        Row(
                          children: [
                            Expanded(
                              child: _SocialButton(
                                label: 'Google',
                                emoji: '🔵',
                                onTap: _submit,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _SocialButton(
                                label: 'Apple',
                                emoji: '🍎',
                                onTap: _submit,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Toggle link
                  GestureDetector(
                    onTap: _toggleMode,
                    child: RichText(
                      text: TextSpan(
                        style: WrapItText.body()
                            .copyWith(color: Colors.white.withValues(alpha: 0.8)),
                        children: [
                          TextSpan(
                            text: _isLogin
                                ? "Don't have an account? "
                                : 'Already have an account? ',
                          ),
                          TextSpan(
                            text: _isLogin ? 'Sign Up' : 'Sign In',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType type = TextInputType.text,
    bool obscure = false,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      keyboardType: type,
      obscureText: obscure,
      style: WrapItText.body().copyWith(color: WrapItColors.textDark),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: WrapItColors.secondary, size: 20),
        suffixIcon: suffix,
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final String emoji;
  final VoidCallback onTap;

  const _SocialButton({
    required this.label,
    required this.emoji,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: WrapItColors.background,
      borderRadius: BorderRadius.circular(WrapItRadius.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(WrapItRadius.lg),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(WrapItRadius.lg),
            border: Border.all(color: WrapItColors.divider, width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(label,
                  style: WrapItText.body()
                      .copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

// InheritedWidget to pass AppState down the tree.
class AppStateProvider extends InheritedWidget {
  final AppState state;

  const AppStateProvider({
    super.key,
    required this.state,
    required super.child,
  });

  static AppState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AppStateProvider>()!
        .state;
  }

  @override
  bool updateShouldNotify(AppStateProvider oldWidget) => true;
}

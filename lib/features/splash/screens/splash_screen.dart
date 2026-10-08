import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routing/app_router.dart';
import '../../../features/form/providers/form_provider.dart';
import '../../../shared/widgets/cbe_logo.dart';
import '../../../shared/widgets/glow_sparkle.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _slideAnim;
  late Animation<double> _scaleAnim;

  bool _showLanguageButtons = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideAnim = Tween<double>(begin: 40, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _scaleAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward().then((_) {
      if (mounted) {
        setState(() => _showLanguageButtons = true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _selectLanguage(BuildContext context, Locale locale) {
    context.read<FormProvider>().setLocale(locale);
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.purpleBackgroundGradient,
        ),
        child: SmogGlowBackground(
          primarySmog: const Color(0x25FFB800),
          secondarySmog: const Color(0x204A0E78),
          child: SafeArea(
            child: Column(
              children: [
                // Top Security Badge
                Padding(
                  padding: const EdgeInsets.only(top: 16, right: 16),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.goldAccent.withValues(alpha: 0.4),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.lock_rounded,
                              color: AppColors.goldAccent, size: 14),
                          SizedBox(width: 6),
                          Text(
                            'Secure Bank',
                            style: TextStyle(
                              color: AppColors.crispWhite,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const Spacer(flex: 2),

                // Logo with Glowing Aura
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) => Opacity(
                    opacity: _fadeAnim.value,
                    child: Transform.translate(
                      offset: Offset(0, _slideAnim.value),
                      child: Transform.scale(
                        scale: _scaleAnim.value,
                        child: child,
                      ),
                    ),
                  ),
                  child: const GlowingContainer(
                    glowColor: AppColors.goldAccent,
                    blurRadius: 28,
                    spreadRadius: 2,
                    child: CbeLogo(size: 96),
                  ),
                ),

                const SizedBox(height: 28),

                // Bank Title & Service Title
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) => Opacity(
                    opacity: _fadeAnim.value,
                    child: Transform.translate(
                      offset: Offset(0, _slideAnim.value * 1.3),
                      child: child,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'የኢትዮጵያ ንግድ ባንክ',
                        style: TextStyle(
                          color: AppColors.goldAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'COMMERCIAL BANK OF ETHIOPIA',
                        style: TextStyle(
                          color: AppColors.crispWhite,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Digital Banking Form Service',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      // Tagline matching infographic
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.goldAccent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.goldAccent.withValues(alpha: 0.4),
                          ),
                        ),
                        child: const Text(
                          'Easy • Secure • Fast',
                          style: TextStyle(
                            color: AppColors.goldAccent,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 2),

                // Reassurance Card
                AnimatedBuilder(
                  animation: _controller,
                  builder: (ctx, child) => Opacity(
                    opacity: _fadeAnim.value,
                    child: child,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.14),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shield_outlined,
                              color: AppColors.goldAccent, size: 18),
                          SizedBox(width: 10),
                          Text(
                            'Your transaction is safe with us',
                            style: TextStyle(
                              color: AppColors.crispWhite,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Language Selection Pills
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: _showLanguageButtons
                      ? Padding(
                          key: const ValueKey('lang-buttons'),
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            children: [
                              Expanded(
                                child: _LangButton(
                                  label: 'English',
                                  isSelected: true,
                                  onTap: () => _selectLanguage(
                                    context,
                                    const Locale('en'),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: _LangButton(
                                  label: 'አማርኛ',
                                  isSelected: false,
                                  onTap: () => _selectLanguage(
                                    context,
                                    const Locale('am'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(
                          key: ValueKey('loading'),
                          height: 54,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.goldAccent,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                ),

                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LangButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LangButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withValues(alpha: 0.18)
              : Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.goldAccent
                : Colors.white.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.goldAccent : AppColors.crispWhite,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

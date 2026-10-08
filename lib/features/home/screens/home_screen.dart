import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routing/app_router.dart';
import '../../../features/form/providers/form_provider.dart';
import '../../../features/form/screens/form_selection_screen.dart';
import '../../../features/history/screens/history_screen.dart';
import '../../../features/teller/screens/teller_scan_screen.dart';
import '../../../shared/widgets/cbe_logo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    _HomeBody(),
    FormSelectionScreen(embedded: true),
    TellerScanScreen(embedded: true),
    HistoryScreen(embedded: true),
    _ProfileBody(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FA),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _LightBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

// ── Home Body ────────────────────────────────────────────────────────────────
class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Deep Royal Purple Header Block (Screen 1 in infographic)
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.deepRoyalPurple,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row with Language & CBE Logo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Language pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.25),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.language_rounded,
                                size: 14, color: AppColors.goldAccent),
                            SizedBox(width: 4),
                            Text(
                              'English / አማርኛ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // CBE Logo top right
                      const CbeLogo(size: 44),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Welcome Header Text
                  const Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'How can we help you today?',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFD4C8E8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Body Content (Cards & Features)
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Cash Deposit Card
                _CleanActionCard(
                  title: 'Cash Deposit',
                  subtitle: 'Fill digital deposit form',
                  icon: Icons.account_balance_wallet_rounded,
                  iconColor: const Color(0xFF10B981),
                  iconBgColor: const Color(0xFFECFDF5),
                  onTap: () {
                    context.read<FormProvider>().setFormType('Cash Deposit');
                    context.push(AppRoutes.formStep1, extra: 'Cash Deposit');
                  },
                ),
                const SizedBox(height: 14),

                // 2. Cash Withdrawal Card
                _CleanActionCard(
                  title: 'Cash Withdrawal',
                  subtitle: 'Fill digital withdrawal form',
                  icon: Icons.payments_rounded,
                  iconColor: const Color(0xFF6D28D9),
                  iconBgColor: const Color(0xFFF3E8FF),
                  onTap: () {
                    context.read<FormProvider>().setFormType('Cash Withdrawal');
                    context.push(AppRoutes.formStep1, extra: 'Cash Withdrawal');
                  },
                ),
                const SizedBox(height: 24),

                // Why Digital Form Section from the infographic
                const Text(
                  'Why Digital Form?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.deepRoyalPurple,
                  ),
                ),
                const SizedBox(height: 12),
                _buildFeatureTile(Icons.insert_drive_file_outlined,
                    'No more paper', 'Save trees and go 100% digital'),
                _buildFeatureTile(Icons.bolt_rounded, 'Fast & accurate',
                    'Automatic calculation and instant teller scan'),
                _buildFeatureTile(Icons.lock_outline_rounded,
                    'Secure & reliable', 'End-to-end encrypted single-use QR'),
                _buildFeatureTile(Icons.thumb_up_alt_outlined,
                    'Easy to use', 'Simple 3-step digital form assistance'),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static Widget _buildFeatureTile(
      IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFECEBF2)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D0047).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F0FA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.deepRoyalPurple, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.deepRoyalPurple,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Clean Action Card matching screenshot 1:1 ─────────────────────────────────
class _CleanActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final VoidCallback onTap;

  const _CleanActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E3ED)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1D0047).withValues(alpha: 0.05),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Colored Icon Box (Green or Purple)
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: iconColor.withValues(alpha: 0.2)),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),

              // Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.deepRoyalPurple,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF9CA3AF),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Profile Body ─────────────────────────────────────────────────────────────
class _ProfileBody extends StatelessWidget {
  const _ProfileBody();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CbeLogo(size: 72, showText: true),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE5E3ED)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1D0047).withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Security & Compliance',
                    style: TextStyle(
                      color: AppColors.deepRoyalPurple,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 12),
                  _LightInfoRow(
                    icon: Icons.security_rounded,
                    title: 'Encryption Standard',
                    value: 'AES-256 CBC',
                  ),
                  _LightInfoRow(
                    icon: Icons.timer_rounded,
                    title: 'QR Code Lifespan',
                    value: '5 Minutes',
                  ),
                  _LightInfoRow(
                    icon: Icons.phone_rounded,
                    title: 'CBE Contact Center',
                    value: '951',
                  ),
                  _LightInfoRow(
                    icon: Icons.verified_user_rounded,
                    title: 'Digital Banking',
                    value: 'Official CBE Form Service',
                    isLast: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LightInfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool isLast;

  const _LightInfoRow({
    required this.icon,
    required this.title,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(icon, color: AppColors.deepRoyalPurple, size: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13),
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.deepRoyalPurple,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(color: Color(0xFFF3F0FA), height: 1),
      ],
    );
  }
}

// ── Light Bottom Nav Bar matching screenshot ─────────────────────────────────
class _LightBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _LightBottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final navItems = [
      const _NavItem(icon: Icons.home_rounded, label: 'Home'),
      const _NavItem(icon: Icons.description_outlined, label: 'My Forms'),
      const _NavItem(icon: Icons.qr_code_scanner_rounded, label: 'Scan'),
      const _NavItem(icon: Icons.history_rounded, label: 'History'),
      const _NavItem(icon: Icons.person_outline_rounded, label: 'Profile'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFECEBF2), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
          8, 8, 8, 8 + MediaQuery.of(context).padding.bottom),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(navItems.length, (index) {
          final isSelected = currentIndex == index;
          final item = navItems[index];

          return InkWell(
            onTap: () => onTap(index),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item.icon,
                    color: isSelected
                        ? AppColors.deepRoyalPurple
                        : const Color(0xFF9CA3AF),
                    size: 22,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.label,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.deepRoyalPurple
                          : const Color(0xFF9CA3AF),
                      fontSize: 10,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

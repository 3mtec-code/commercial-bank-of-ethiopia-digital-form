import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routing/app_router.dart';
import '../../../features/form/providers/form_provider.dart';
import '../../../features/form/screens/form_selection_screen.dart';
import '../../../features/history/screens/history_screen.dart';
import '../../../l10n/app_localizations.dart';
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
    HistoryScreen(embedded: true),
    _ProfileBody(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<FormProvider>().isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F0024) : const Color(0xFFF7F6FA),
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
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<FormProvider>();
    final isDark = provider.isDarkMode;
    final isAmharic = provider.locale.languageCode == 'am';

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
                  // Top Row with Language Toggle & CBE Logo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Language pill toggle
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => provider.toggleLocale(),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.goldAccent.withValues(alpha: 0.4),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.language_rounded,
                                    size: 14, color: AppColors.goldAccent),
                                const SizedBox(width: 6),
                                Text(
                                  isAmharic ? 'አማርኛ' : 'English',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.swap_horiz_rounded,
                                    size: 14, color: AppColors.goldAccent),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // CBE Logo top right
                      const CbeLogo(size: 44),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Welcome Header Text
                  Text(
                    l10n.welcome,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.welcomeSubtitle,
                    style: const TextStyle(
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
                  title: l10n.cashDeposit,
                  subtitle: l10n.fillDepositForm,
                  icon: Icons.account_balance_wallet_rounded,
                  iconColor: const Color(0xFF10B981),
                  iconBgColor: isDark ? const Color(0xFF064E3B) : const Color(0xFFECFDF5),
                  isDark: isDark,
                  onTap: () {
                    provider.setFormType('Cash Deposit');
                    context.push(AppRoutes.formStep1, extra: 'Cash Deposit');
                  },
                ),
                const SizedBox(height: 14),

                // 2. Cash Withdrawal Card
                _CleanActionCard(
                  title: l10n.cashWithdrawal,
                  subtitle: l10n.fillWithdrawalForm,
                  icon: Icons.payments_rounded,
                  iconColor: const Color(0xFF6D28D9),
                  iconBgColor: isDark ? const Color(0xFF3B0764) : const Color(0xFFF3E8FF),
                  isDark: isDark,
                  onTap: () {
                    provider.setFormType('Cash Withdrawal');
                    context.push(AppRoutes.formStep1, extra: 'Cash Withdrawal');
                  },
                ),
                const SizedBox(height: 24),

                // Why Digital Form Section from the infographic
                Text(
                  l10n.whyDigitalForm,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : AppColors.deepRoyalPurple,
                  ),
                ),
                const SizedBox(height: 12),
                _buildFeatureTile(
                  icon: Icons.insert_drive_file_outlined,
                  title: l10n.noMorePaper,
                  subtitle: l10n.noMorePaperDesc,
                  isDark: isDark,
                ),
                _buildFeatureTile(
                  icon: Icons.bolt_rounded,
                  title: l10n.fastAndAccurate,
                  subtitle: l10n.fastAndAccurateDesc,
                  isDark: isDark,
                ),
                _buildFeatureTile(
                  icon: Icons.lock_outline_rounded,
                  title: l10n.secureAndReliable,
                  subtitle: l10n.secureAndReliableDesc,
                  isDark: isDark,
                ),
                _buildFeatureTile(
                  icon: Icons.thumb_up_alt_outlined,
                  title: l10n.easyToUse,
                  subtitle: l10n.easyToUseDesc,
                  isDark: isDark,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static Widget _buildFeatureTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1D0047) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.12) : const Color(0xFFECEBF2),
        ),
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
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : const Color(0xFFF3F0FA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: isDark ? AppColors.goldAccent : AppColors.deepRoyalPurple,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.deepRoyalPurple,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? const Color(0xFFB8A9D4) : const Color(0xFF6B7280),
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
  final bool isDark;
  final VoidCallback onTap;

  const _CleanActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    this.isDark = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDark ? const Color(0xFF1D0047) : Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.12)
                  : const Color(0xFFE5E3ED),
            ),
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : AppColors.deepRoyalPurple,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? const Color(0xFFB8A9D4) : const Color(0xFF6B7280),
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
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<FormProvider>();
    final isDark = provider.isDarkMode;
    final isAmharic = provider.locale.languageCode == 'am';

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CbeLogo(size: 72, showText: true),
            const SizedBox(height: 24),

            // 1. Security & Compliance Card (Existing layout preserved)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1D0047) : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.12)
                      : const Color(0xFFE5E3ED),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1D0047).withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.securityAndCompliance,
                    style: TextStyle(
                      color: isDark ? AppColors.goldAccent : AppColors.deepRoyalPurple,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _LightInfoRow(
                    icon: Icons.security_rounded,
                    title: l10n.encryptionStandard,
                    value: l10n.encryptionValue,
                    isDark: isDark,
                  ),
                  _LightInfoRow(
                    icon: Icons.timer_rounded,
                    title: l10n.qrLifespan,
                    value: l10n.qrLifespanValue,
                    isDark: isDark,
                  ),
                  _LightInfoRow(
                    icon: Icons.phone_rounded,
                    title: l10n.cbeContactCenter,
                    value: l10n.cbeContactValue,
                    isDark: isDark,
                  ),
                  _LightInfoRow(
                    icon: Icons.verified_user_rounded,
                    title: l10n.digitalBanking,
                    value: l10n.digitalBankingValue,
                    isLast: true,
                    isDark: isDark,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 2. Preferences & Features Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1D0047) : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.12)
                      : const Color(0xFFE5E3ED),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1D0047).withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.preferences,
                    style: TextStyle(
                      color: isDark ? AppColors.goldAccent : AppColors.deepRoyalPurple,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Dark Mode / Light Mode Switch
                  _SettingSwitchRow(
                    icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    title: isDark ? l10n.darkMode : l10n.lightMode,
                    value: isDark,
                    onChanged: (val) => provider.toggleTheme(),
                    isDark: isDark,
                  ),
                  const Divider(color: Color(0xFFF3F0FA), height: 1),

                  // Language Preference Toggle
                  _SettingActionRow(
                    icon: Icons.translate_rounded,
                    title: l10n.languagePreference,
                    trailingText: isAmharic ? 'አማርኛ' : 'English',
                    onTap: () => _showLanguageDialog(context, provider),
                    isDark: isDark,
                  ),
                  const Divider(color: Color(0xFFF3F0FA), height: 1),

                  // Push Notifications Switch
                  _SettingSwitchRow(
                    icon: Icons.notifications_active_outlined,
                    title: l10n.pushNotifications,
                    value: provider.notificationsEnabled,
                    onChanged: (val) => provider.setNotificationsEnabled(val),
                    isDark: isDark,
                  ),
                  const Divider(color: Color(0xFFF3F0FA), height: 1),

                  // Help & Support / FAQ Link
                  _SettingActionRow(
                    icon: Icons.help_outline_rounded,
                    title: l10n.helpAndSupport,
                    trailingText: isAmharic ? 'ጥያቄዎች' : 'FAQ',
                    onTap: () => _showHelpBottomSheet(context, l10n, isDark),
                    isDark: isDark,
                  ),
                  const Divider(color: Color(0xFFF3F0FA), height: 1),

                  // Clear Cache / Local Storage
                  _SettingActionRow(
                    icon: Icons.delete_outline_rounded,
                    title: l10n.clearCache,
                    iconColor: AppColors.error,
                    titleColor: AppColors.error,
                    onTap: () => _confirmClearCache(context, provider, l10n),
                    isDark: isDark,
                  ),
                  const Divider(color: Color(0xFFF3F0FA), height: 1),

                  // App Version Info
                  _LightInfoRow(
                    icon: Icons.info_outline_rounded,
                    title: l10n.appVersion,
                    value: l10n.appVersionValue,
                    isLast: true,
                    isDark: isDark,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  static void _showLanguageDialog(BuildContext context, FormProvider provider) {
    final l10n = AppLocalizations.of(context);
    final isDark = provider.isDarkMode;
    final isAmharic = provider.locale.languageCode == 'am';

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1D0047) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.selectLanguage,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : AppColors.deepRoyalPurple,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.language_rounded, color: AppColors.deepRoyalPurple),
                  title: const Text('English', style: TextStyle(fontWeight: FontWeight.w600)),
                  trailing: provider.locale.languageCode == 'en'
                      ? const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981))
                      : null,
                  onTap: () {
                    provider.setLocale(const Locale('en'));
                    Navigator.pop(ctx);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.language_rounded, color: AppColors.deepRoyalPurple),
                  title: Text(isAmharic ? 'አማርኛ' : 'Amharic (አማርኛ)', style: const TextStyle(fontWeight: FontWeight.w600)),
                  trailing: provider.locale.languageCode == 'am'
                      ? const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981))
                      : null,
                  onTap: () {
                    provider.setLocale(const Locale('am'));
                    Navigator.pop(ctx);
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  static void _showHelpBottomSheet(
      BuildContext context, AppLocalizations l10n, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1D0047) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          expand: false,
          builder: (_, controller) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: ListView(
                controller: controller,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.faqTitle,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : AppColors.deepRoyalPurple,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFaqItem(l10n.faqQ1, l10n.faqA1, isDark),
                  _buildFaqItem(l10n.faqQ2, l10n.faqA2, isDark),
                  _buildFaqItem(l10n.faqQ3, l10n.faqA3, isDark),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.deepRoyalPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(l10n.close),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  static Widget _buildFaqItem(String question, String answer, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.1) : const Color(0xFFECEBF2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.help_rounded, size: 16, color: AppColors.goldAccent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  question,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.deepRoyalPurple,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            answer,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? const Color(0xFFD4C8E8) : const Color(0xFF4B5563),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  static void _confirmClearCache(
      BuildContext context, FormProvider provider, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            l10n.clearCacheConfirmTitle,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          content: Text(l10n.clearCacheConfirmMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(ctx);
                await provider.clearCacheAndStorage();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.clearCacheSuccess),
                      backgroundColor: const Color(0xFF10B981),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(l10n.clearCache),
            ),
          ],
        );
      },
    );
  }
}

class _SettingSwitchRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isDark;

  const _SettingSwitchRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon,
              color: isDark ? AppColors.goldAccent : AppColors.deepRoyalPurple,
              size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF1E1435),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Switch.adaptive(
            value: value,
            activeTrackColor: AppColors.goldAccent,
            activeThumbColor: AppColors.deepRoyalPurple,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _SettingActionRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailingText;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? titleColor;
  final bool isDark;

  const _SettingActionRow({
    required this.icon,
    required this.title,
    this.trailingText,
    required this.onTap,
    this.iconColor,
    this.titleColor,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor ??
                  (isDark ? AppColors.goldAccent : AppColors.deepRoyalPurple),
              size: 18,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: titleColor ??
                      (isDark ? Colors.white : const Color(0xFF1E1435)),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (trailingText != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : const Color(0xFFF3F0FA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  trailingText!,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.goldAccent : AppColors.deepRoyalPurple,
                  ),
                ),
              ),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF9CA3AF),
              size: 20,
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
  final bool isDark;

  const _LightInfoRow({
    required this.icon,
    required this.title,
    required this.value,
    this.isLast = false,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(icon,
                  color: isDark ? AppColors.goldAccent : AppColors.deepRoyalPurple,
                  size: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isDark ? const Color(0xFFB8A9D4) : const Color(0xFF6B7280),
                    fontSize: 13,
                  ),
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: isDark ? Colors.white : AppColors.deepRoyalPurple,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            color: isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFF3F0FA),
            height: 1,
          ),
      ],
    );
  }
}

// ── Light Bottom Nav Bar (ONLY 4 TABS: Home, My Forms, History, Profile) ─────
class _LightBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _LightBottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = context.watch<FormProvider>().isDarkMode;

    final navItems = [
      _NavItem(icon: Icons.home_rounded, label: l10n.home),
      _NavItem(icon: Icons.description_outlined, label: l10n.myForms),
      _NavItem(icon: Icons.history_rounded, label: l10n.history),
      _NavItem(icon: Icons.person_outline_rounded, label: l10n.profile),
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF160036) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.white.withValues(alpha: 0.1) : const Color(0xFFECEBF2),
            width: 1,
          ),
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

          final selectedColor = isDark ? AppColors.goldAccent : AppColors.deepRoyalPurple;
          final unselectedColor = isDark ? const Color(0xFF8C7DA7) : const Color(0xFF9CA3AF);

          return InkWell(
            onTap: () => onTap(index),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item.icon,
                    color: isSelected ? selectedColor : unselectedColor,
                    size: 22,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.label,
                    style: TextStyle(
                      color: isSelected ? selectedColor : unselectedColor,
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

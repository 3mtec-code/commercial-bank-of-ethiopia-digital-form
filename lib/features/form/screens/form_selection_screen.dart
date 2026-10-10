import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routing/app_router.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/form_provider.dart';

class FormSelectionScreen extends StatelessWidget {
  final bool embedded;

  const FormSelectionScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = context.watch<FormProvider>().isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F0024) : const Color(0xFFF7F6FA),
      appBar: AppBar(
        backgroundColor: AppColors.deepRoyalPurple,
        elevation: 0,
        leading: (!embedded && Navigator.canPop(context))
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 20),
                onPressed: () => Navigator.of(context).maybePop(),
              )
            : null,
        title: Text(
          l10n.selectFormType,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subtitle matching screenshot
              Text(
                l10n.chooseForm,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? const Color(0xFFB8A9D4) : const Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 24),

              // 1. Cash Deposit Voucher
              _FormSelectionCard(
                title: l10n.cashDepositVoucher,
                subtitle: l10n.fillDepositSlip,
                icon: Icons.account_balance_wallet_rounded,
                iconColor: const Color(0xFF10B981),
                iconBgColor: isDark ? const Color(0xFF064E3B) : const Color(0xFFECFDF5),
                isDark: isDark,
                onTap: () {
                  context.read<FormProvider>().setFormType('Cash Deposit');
                  context.push(AppRoutes.formStep1, extra: 'Cash Deposit');
                },
              ),
              const SizedBox(height: 16),

              // 2. Cash Withdrawal Form
              _FormSelectionCard(
                title: l10n.cashWithdrawalForm,
                subtitle: l10n.fillWithdrawalSlip,
                icon: Icons.payments_rounded,
                iconColor: const Color(0xFF6D28D9),
                iconBgColor: isDark ? const Color(0xFF3B0764) : const Color(0xFFF3E8FF),
                showArrow: true,
                isDark: isDark,
                onTap: () {
                  context.read<FormProvider>().setFormType('Cash Withdrawal');
                  context.push(AppRoutes.formStep1, extra: 'Cash Withdrawal');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormSelectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final bool showArrow;
  final bool isDark;
  final VoidCallback onTap;

  const _FormSelectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    this.showArrow = false,
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
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.12)
                  : const Color(0xFFE5E7EB),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF1E1435),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? const Color(0xFFB8A9D4) : const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: showArrow ? const Color(0xFF6D28D9) : const Color(0xFF9CA3AF),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routing/app_router.dart';
import '../../../features/form/providers/form_provider.dart';
import '../../../features/utils/number_to_words.dart';
import '../../../l10n/app_localizations.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<FormProvider>();
    final isDark = provider.isDarkMode;
    final isAmharic = provider.locale.languageCode == 'am';
    final isDeposit = provider.formType == AppConstants.formTypeDeposit ||
        provider.formType.toLowerCase().contains('deposit') ||
        provider.formType.contains('ገቢ');

    final branch = _translateBranch(provider.branch, isAmharic);
    final date = provider.date.isNotEmpty ? provider.date : (isAmharic ? '21/07/2026' : '21 Jul 2026');
    final accountHolder = provider.accountHolderName.isNotEmpty
        ? provider.accountHolderName
        : (isAmharic ? 'አበበ ከበደ' : 'Abebe Kebede');
    final accountNumber = provider.accountNumber.isNotEmpty
        ? provider.accountNumber
        : '1000 1234 56789';
    final accountType = _translateAccountType(provider.accountType, l10n);
    final totalAmount = provider.totalAmount > 0 ? provider.totalAmount : 5000.0;
    final amountInWords = provider.amountInWords.isNotEmpty
        ? provider.amountInWords
        : NumberToWords.convert(totalAmount, provider.locale.languageCode);

    final sourceLabel = _getSourceLabel(provider.sourceOfProceeds, l10n);
    final phone = provider.phoneNumber.isNotEmpty ? provider.phoneNumber : '0912345678';
    final person = provider.depositedBy.isNotEmpty
        ? provider.depositedBy
        : accountHolder;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F0024) : const Color(0xFFF7F6FA),
      appBar: AppBar(
        backgroundColor: AppColors.deepRoyalPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.reviewYourForm,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Subtitle
            Container(
              width: double.infinity,
              color: AppColors.deepRoyalPurple,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isAmharic ? 'የቅጽ ማጠቃለያ' : 'Form Summary',
                    style: const TextStyle(
                      color: Color(0xFFD4C8E8),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Review Card
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1D0047) : Colors.white,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildReviewRow(
                        icon: Icons.account_balance_outlined,
                        label: l10n.branch,
                        value: branch,
                        isDark: isDark,
                      ),
                      _divider(isDark),

                      _buildReviewRow(
                        icon: Icons.calendar_today_outlined,
                        label: l10n.date,
                        value: date,
                        isDark: isDark,
                      ),
                      _divider(isDark),

                      _buildReviewRow(
                        icon: Icons.person_outline_rounded,
                        label: l10n.accountHolderWithSurname,
                        value: accountHolder,
                        isDark: isDark,
                      ),
                      _divider(isDark),

                      _buildReviewRow(
                        icon: Icons.credit_card_rounded,
                        label: l10n.accountNumber,
                        value: accountNumber,
                        isDark: isDark,
                      ),
                      _divider(isDark),

                      _buildReviewRow(
                        icon: Icons.account_circle_outlined,
                        label: l10n.accountType,
                        value: accountType,
                        isDark: isDark,
                      ),
                      _divider(isDark),

                      _buildReviewRow(
                        icon: Icons.monetization_on_outlined,
                        label: l10n.amountFigure,
                        value: '${_formatAmount(totalAmount)} ${isAmharic ? "ብር" : "ETB"}',
                        isHighlighted: true,
                        isDark: isDark,
                      ),
                      _divider(isDark),

                      _buildReviewRow(
                        icon: Icons.notes_rounded,
                        label: l10n.amountWords,
                        value: amountInWords,
                        isDark: isDark,
                      ),
                      _divider(isDark),

                      _buildReviewRow(
                        icon: Icons.source_rounded,
                        label: l10n.sourceOfProceeds,
                        value: sourceLabel,
                        isDark: isDark,
                      ),
                      _divider(isDark),

                      _buildReviewRow(
                        icon: Icons.phone_rounded,
                        label: l10n.telephoneNumber,
                        value: phone,
                        isDark: isDark,
                      ),
                      _divider(isDark),

                      _buildReviewRow(
                        icon: Icons.badge_outlined,
                        label: isDeposit ? l10n.depositedBy : l10n.withdrawnBy,
                        value: person,
                        isDark: isDark,
                      ),

                      // Signature thumbnail if present
                      if (provider.signatureBytes != null) ...[
                        _divider(isDark),
                        Text(
                          isDeposit ? l10n.depositedBySignature : l10n.accountHolderSignature,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? const Color(0xFFB8A9D4) : const Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: Center(
                            child: Image.memory(
                              provider.signatureBytes!,
                              height: 50,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Action Buttons: Edit & Confirm
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF160036) : Colors.white,
                border: Border(
                  top: BorderSide(
                    color: isDark ? Colors.white.withValues(alpha: 0.1) : const Color(0xFFE5E7EB),
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Edit Button
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () => context.pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDark ? Colors.white : const Color(0xFF1E1435),
                          side: BorderSide(
                            color: isDark ? Colors.white.withValues(alpha: 0.2) : const Color(0xFFD1D5DB),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
                          l10n.edit,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Confirm Button
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          // Generate transaction & QR
                          await provider.submitForm();
                          if (context.mounted) {
                            context.push(AppRoutes.qr);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.deepRoyalPurple,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
                          l10n.confirm,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
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
    );
  }

  Widget _divider(bool isDark) {
    return Divider(
      color: isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFF3F4F6),
      height: 24,
    );
  }

  Widget _buildReviewRow({
    required IconData icon,
    required String label,
    required String value,
    bool isHighlighted = false,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: isDark ? AppColors.goldAccent : const Color(0xFF6B7280),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark ? const Color(0xFFB8A9D4) : const Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: isHighlighted ? 15 : 14,
                  fontWeight: isHighlighted ? FontWeight.w800 : FontWeight.w600,
                  color: isHighlighted
                      ? (isDark ? AppColors.goldAccent : AppColors.deepRoyalPurple)
                      : (isDark ? Colors.white : const Color(0xFF1E1435)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static String _formatAmount(double amt) {
    return amt.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  static const List<String> _branchSuggestionsEn = [
    'Addis Ababa Main Branch',
    'Finfine Branch',
    'Bole Branch',
    'Megenagna Branch',
    'Piazza Branch',
    'Sarbet Branch',
    'Kera Branch',
    'Hawassa Branch',
    'Bahir Dar Branch',
    'Adama Branch',
  ];

  static const List<String> _branchSuggestionsAm = [
    'አዲስ አበባ ዋና ቅርንጫፍ',
    'ፊንፊኔ ቅርንጫፍ',
    'ቦሌ ቅርንጫፍ',
    'መገናኛ ቅርንጫፍ',
    'ፒያሳ ቅርንጫፍ',
    'ሳርቤት ቅርንጫፍ',
    'ቄራ ቅርንጫፍ',
    'ሀዋሳ ቅርንጫፍ',
    'ባህር ዳር ቅርንጫፍ',
    'አዳማ ቅርንጫፍ',
  ];

  static String _translateBranch(String branch, bool isAmharic) {
    if (branch.isEmpty) {
      return isAmharic ? _branchSuggestionsAm.first : _branchSuggestionsEn.first;
    }
    final enIdx = _branchSuggestionsEn.indexOf(branch);
    if (enIdx != -1) {
      return isAmharic ? _branchSuggestionsAm[enIdx] : _branchSuggestionsEn[enIdx];
    }
    final amIdx = _branchSuggestionsAm.indexOf(branch);
    if (amIdx != -1) {
      return isAmharic ? _branchSuggestionsAm[amIdx] : _branchSuggestionsEn[amIdx];
    }
    return branch;
  }

  static String _translateAccountType(String type, AppLocalizations l10n) {
    final lower = type.toLowerCase();
    if (lower.contains('current') || lower.contains('የወቅታዊ')) {
      return l10n.currentAccount;
    }
    if (lower.contains('special') || lower.contains('demand') || lower.contains('ተፈላጊ')) {
      return l10n.specialDemand;
    }
    return l10n.savingAccount;
  }

  static String _getSourceLabel(String key, AppLocalizations l10n) {
    switch (key) {
      case 'Salary':
        return l10n.sourceSalary;
      case 'Business':
        return l10n.sourceBusiness;
      case 'Remittance':
        return l10n.sourceRemittance;
      case 'Savings':
        return l10n.sourceSavings;
      case 'Investment':
        return l10n.sourceInvestment;
      default:
        return l10n.sourceOther;
    }
  }
}

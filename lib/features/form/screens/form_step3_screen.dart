import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routing/app_router.dart';
import '../../../l10n/app_localizations.dart';
import '../../utils/number_to_words.dart';
import '../providers/form_provider.dart';

class FormStep3Screen extends StatefulWidget {
  const FormStep3Screen({super.key});

  @override
  State<FormStep3Screen> createState() => _FormStep3ScreenState();
}

class _FormStep3ScreenState extends State<FormStep3Screen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountWordsCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _personCtrl;

  String? _selectedSourceKey;
  late SignatureController _signatureController;
  bool _signatureError = false;

  final List<String> _sourceKeys = [
    'Salary',
    'Business',
    'Remittance',
    'Savings',
    'Investment',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    final p = context.read<FormProvider>();

    _amountWordsCtrl = TextEditingController(
      text: p.amountInWords.isNotEmpty
          ? p.amountInWords
          : (p.totalAmount > 0
              ? NumberToWords.convert(p.totalAmount, p.locale.languageCode)
              : ''),
    );
    _phoneCtrl = TextEditingController(text: p.phoneNumber);
    _personCtrl = TextEditingController(
      text: p.depositedBy.isNotEmpty
          ? p.depositedBy
          : (p.accountHolderName.isNotEmpty ? p.accountHolderName : ''),
    );
    _selectedSourceKey = p.sourceOfProceeds.isNotEmpty ? p.sourceOfProceeds : 'Salary';

    _signatureController = SignatureController(
      penStrokeWidth: 2.5,
      penColor: const Color(0xFF1E1435),
      exportBackgroundColor: Colors.white,
    );
  }

  @override
  void dispose() {
    _amountWordsCtrl.dispose();
    _phoneCtrl.dispose();
    _personCtrl.dispose();
    _signatureController.dispose();
    super.dispose();
  }

  String _getSourceLabel(String key, AppLocalizations l10n) {
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

  Future<void> _goToReview() async {
    final l10n = AppLocalizations.of(context);
    final p = context.read<FormProvider>();

    final hasSig = _signatureController.isNotEmpty || p.signatureBytes != null;
    setState(() => _signatureError = !hasSig);

    if (!_formKey.currentState!.validate()) return;
    if (!hasSig) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.errorSignatureRequired),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    p.setAmountInWords(_amountWordsCtrl.text.trim());
    p.setSourceOfProceeds(_selectedSourceKey ?? 'Salary');
    p.setPhoneNumber(_phoneCtrl.text.replaceAll(' ', '').trim());
    p.setDepositedBy(_personCtrl.text.trim());

    if (_signatureController.isNotEmpty) {
      final sigBytes = await _signatureController.toPngBytes();
      if (sigBytes != null) {
        p.setSignature(sigBytes);
      }
    }

    if (mounted) {
      context.push(AppRoutes.review);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<FormProvider>();
    final isDark = provider.isDarkMode;
    final isAmharic = provider.locale.languageCode == 'am';

    if (_amountWordsCtrl.text.isEmpty && provider.amountInWords.isNotEmpty) {
      _amountWordsCtrl.text = provider.amountInWords;
    }

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
          l10n.otherDetails,
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
            // Top Stepper Subtitle
            Container(
              width: double.infinity,
              color: AppColors.deepRoyalPurple,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.step3Of3,
                    style: const TextStyle(
                      color: Color(0xFFD4C8E8),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Form Fields in clean card
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.all(18),
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
                        // Amount In Words
                        _buildLabel(l10n.amountInWords, isDark),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _amountWordsCtrl,
                          maxLines: 2,
                          style: TextStyle(
                            color: isDark ? Colors.white : const Color(0xFF1E1435),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: _inputDecoration(
                            hint: isAmharic
                                ? 'ለምሳሌ አምስት ሺህ ብር ብቻ'
                                : 'e.g. Five Thousand Birr Only',
                            isDark: isDark,
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? l10n.errorAmountInWordsRequired
                              : null,
                        ),
                        const SizedBox(height: 16),

                        // Source of Proceeds Dropdown
                        _buildLabel(l10n.sourceOfProceeds, isDark),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedSourceKey,
                          style: TextStyle(
                            color: isDark ? Colors.white : const Color(0xFF1E1435),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          dropdownColor: isDark ? const Color(0xFF1D0047) : Colors.white,
                          decoration: _inputDecoration(
                            hint: l10n.selectSource,
                            isDark: isDark,
                          ),
                          items: _sourceKeys.map((k) {
                            return DropdownMenuItem(
                              value: k,
                              child: Text(_getSourceLabel(k, l10n)),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() => _selectedSourceKey = val);
                          },
                        ),
                        const SizedBox(height: 16),

                        // Telephone Number
                        _buildLabel(l10n.telephoneNumber, isDark),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _phoneCtrl,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[\d\+\s]')),
                            LengthLimitingTextInputFormatter(16),
                          ],
                          style: TextStyle(
                            color: isDark ? Colors.white : const Color(0xFF1E1435),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: _inputDecoration(
                            hint: '0912345678',
                            isDark: isDark,
                          ),
                          validator: (v) {
                            final phone = (v ?? '').replaceAll(RegExp(r'\s+'), '');
                            if (phone.isEmpty) return l10n.errorPhoneRequired;
                            // Ethiopian phone validation (10 digits starting with 09 or 07, or international format +251)
                            final ethRegex = RegExp(r'^(?:\+251[79]\d{8}|251[79]\d{8}|0[79]\d{8})$');
                            if (!ethRegex.hasMatch(phone)) {
                              return l10n.errorPhoneInvalid;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Deposited By / Withdrawn By
                        _buildLabel(
                          (provider.formType.toLowerCase().contains('withdrawal') ||
                                  provider.formType.contains('ወጪ'))
                              ? l10n.withdrawnBy
                              : l10n.depositedBy,
                          isDark,
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _personCtrl,
                          textCapitalization: TextCapitalization.words,
                          inputFormatters: [
                            // Restrict to letters/characters only
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z\s\u1200-\u137F]')),
                          ],
                          style: TextStyle(
                            color: isDark ? Colors.white : const Color(0xFF1E1435),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: _inputDecoration(
                            hint: isAmharic ? 'ለምሳሌ አበበ ከበደ' : 'e.g. Abebe Kebede',
                            isDark: isDark,
                          ),
                          validator: (v) {
                            final trimmed = v?.trim() ?? '';
                            if (trimmed.isEmpty) return l10n.errorDepositorRequired;
                            if (!RegExp(r'^[a-zA-Z\s\u1200-\u137F]+$').hasMatch(trimmed)) {
                              return l10n.errorLettersOnly;
                            }
                            if (trimmed.length < 3) return l10n.errorMin3Chars;
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),

                        // Deposited By / Account Holder Signature
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildLabel(
                              (provider.formType.toLowerCase().contains('withdrawal') ||
                                      provider.formType.contains('ወጪ'))
                                  ? l10n.accountHolderSignature
                                  : l10n.depositedBySignature,
                              isDark,
                            ),
                            TextButton(
                              onPressed: () {
                                _signatureController.clear();
                                context.read<FormProvider>().clearSignature();
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(44, 28),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                l10n.clear,
                                style: const TextStyle(
                                  color: Color(0xFF6B7280),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF230545) : const Color(0xFFFAFAFA),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _signatureError
                                  ? AppColors.error
                                  : (isDark
                                      ? Colors.white.withValues(alpha: 0.15)
                                      : const Color(0xFFE5E7EB)),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Signature(
                              controller: _signatureController,
                              backgroundColor:
                                  isDark ? const Color(0xFF230545) : const Color(0xFFFAFAFA),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Buttons: Back & Review
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
                  // Back Button (Outlined pill)
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
                          l10n.back,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Review Button (Deep purple pill)
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _goToReview,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.deepRoyalPurple,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
                          l10n.review,
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

  Widget _buildLabel(String text, bool isDark) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white : const Color(0xFF374151),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint, required bool isDark}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFF9CA3AF),
        fontSize: 13,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      filled: true,
      fillColor: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: isDark ? Colors.white.withValues(alpha: 0.15) : const Color(0xFFE5E7EB),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: isDark ? Colors.white.withValues(alpha: 0.15) : const Color(0xFFE5E7EB),
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: AppColors.deepRoyalPurple, width: 1.5),
      ),
    );
  }
}

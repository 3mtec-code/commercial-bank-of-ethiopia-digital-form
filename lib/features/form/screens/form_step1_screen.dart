import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routing/app_router.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/form_provider.dart';
import '../../../shared/widgets/step_indicator.dart';

class FormStep1Screen extends StatefulWidget {
  final String formType;
  const FormStep1Screen({super.key, required this.formType});

  @override
  State<FormStep1Screen> createState() => _FormStep1ScreenState();
}

class _FormStep1ScreenState extends State<FormStep1Screen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _accCtrl;
  late TextEditingController _dateCtrl;
  late TextEditingController _branchCtrl;
  late TextEditingController _amountFigureCtrl;

  bool _passbookAccompanied = true;

  final List<String> _branchSuggestionsEn = [
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

  final List<String> _branchSuggestionsAm = [
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

  @override
  void initState() {
    super.initState();
    final p = context.read<FormProvider>();
    final isAmharic = p.locale.languageCode == 'am';

    _nameCtrl = TextEditingController(text: p.accountHolderName);
    _accCtrl = TextEditingController(
      text: p.accountNumber.isNotEmpty
          ? _formatAccountNumber(p.accountNumber)
          : '',
    );
    _branchCtrl = TextEditingController(
      text: p.branch.isNotEmpty
          ? p.branch
          : (isAmharic ? _branchSuggestionsAm.first : _branchSuggestionsEn.first),
    );
    _dateCtrl = TextEditingController(
      text: p.date.isNotEmpty
          ? p.date
          : (isAmharic
              ? DateFormat('dd/MM/yyyy').format(DateTime.now())
              : DateFormat('dd MMM yyyy').format(DateTime.now())),
    );
    _amountFigureCtrl = TextEditingController(
      text: p.totalAmount > 0 ? p.totalAmount.toStringAsFixed(2) : '',
    );
  }

  static String _formatAccountNumber(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i == 4 || i == 8) buffer.write(' ');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _accCtrl.dispose();
    _dateCtrl.dispose();
    _branchCtrl.dispose();
    _amountFigureCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
      builder: (ctx, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.deepRoyalPurple,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: AppColors.deepRoyalPurple,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null && mounted) {
      final isAmharic = context.read<FormProvider>().locale.languageCode == 'am';
      final formatted = isAmharic
          ? DateFormat('dd/MM/yyyy').format(picked)
          : DateFormat('dd MMM yyyy').format(picked);
      _dateCtrl.text = formatted;
      context.read<FormProvider>().setDate(formatted);
    }
  }

  void _next() {
    if (_formKey.currentState!.validate()) {
      final p = context.read<FormProvider>();
      p.setBranch(_branchCtrl.text.trim());
      p.setDate(_dateCtrl.text.trim());
      p.setAccountHolderName(_nameCtrl.text.trim());
      p.setAccountNumber(_accCtrl.text.replaceAll(' ', '').trim());
      p.setFormType(widget.formType);

      if (!_isDeposit && _amountFigureCtrl.text.isNotEmpty) {
        final amt = double.tryParse(_amountFigureCtrl.text.replaceAll(',', '')) ?? 0.0;
        if (amt > 0 && p.totalAmount == 0) {
          p.setManualAmount(amt);
        }
      }

      context.push(AppRoutes.formStep2);
    }
  }

  bool get _isDeposit =>
      widget.formType == AppConstants.formTypeDeposit ||
      widget.formType.toLowerCase().contains('deposit') ||
      widget.formType.contains('ገቢ');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<FormProvider>();
    final isDark = provider.isDarkMode;
    final isAmharic = provider.locale.languageCode == 'am';
    final branchList = isAmharic ? _branchSuggestionsAm : _branchSuggestionsEn;

    // Automatically synchronize selected branch with language if changed
    if (isAmharic) {
      final enIndex = _branchSuggestionsEn.indexOf(_branchCtrl.text);
      if (enIndex != -1) {
        _branchCtrl.text = _branchSuggestionsAm[enIndex];
      }
    } else {
      final amIndex = _branchSuggestionsAm.indexOf(_branchCtrl.text);
      if (amIndex != -1) {
        _branchCtrl.text = _branchSuggestionsEn[amIndex];
      }
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
          _isDeposit ? l10n.fillDepositVoucher : l10n.fillWithdrawalFormHeader,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Deep Purple Header Stepper Band matching screenshot
          Container(
            color: AppColors.deepRoyalPurple,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: StepIndicator(
              currentStep: 1,
              totalSteps: 3,
              stepLabels: [
                l10n.stepAccountInfo,
                l10n.stepDenominations,
                l10n.stepDetails,
              ],
            ),
          ),

          // Clean form body
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.step1Of3,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? const Color(0xFFB8A9D4) : const Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Branch Field
                    _buildLabel(l10n.branch, isDark),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: branchList.contains(_branchCtrl.text)
                          ? _branchCtrl.text
                          : branchList.first,
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF1E1435),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      dropdownColor: isDark ? const Color(0xFF1D0047) : Colors.white,
                      decoration: _inputDecoration(
                        hint: l10n.selectBranch,
                        isDark: isDark,
                      ),
                      items: branchList.map((b) {
                        return DropdownMenuItem(
                          value: b,
                          child: Text(b),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          _branchCtrl.text = val;
                          provider.setBranch(val);
                        }
                      },
                      validator: (v) =>
                          (v == null || v.isEmpty) ? l10n.errorSelectBranch : null,
                    ),
                    const SizedBox(height: 16),

                    // Date Field
                    _buildLabel(l10n.date, isDark),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _dateCtrl,
                      readOnly: true,
                      onTap: _pickDate,
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF1E1435),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: _inputDecoration(
                        hint: isAmharic ? 'ቀን ይምረጡ' : 'Select Date',
                        suffixIcon: const Icon(Icons.calendar_today_outlined,
                            size: 18, color: Color(0xFF6B7280)),
                        isDark: isDark,
                      ),
                      validator: (v) => (v == null || v.isEmpty) ? l10n.errorSelectDate : null,
                    ),
                    const SizedBox(height: 16),

                    // Account Holder Field
                    _buildLabel(l10n.accountHolderWithSurname, isDark),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _nameCtrl,
                      textCapitalization: TextCapitalization.words,
                      inputFormatters: [
                        // Restrict input to letters/characters only (Amharic alphabets, English alphabets, and spaces allowed)
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s\u1200-\u137F]')),
                      ],
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF1E1435),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: _inputDecoration(
                        hint: isAmharic ? 'አበበ ከበደ' : 'Abebe Kebede',
                        isDark: isDark,
                      ),
                      validator: (v) {
                        final trimmed = v?.trim() ?? '';
                        if (trimmed.isEmpty) return l10n.errorAccountHolderRequired;
                        if (!RegExp(r'^[a-zA-Z\s\u1200-\u137F]+$').hasMatch(trimmed)) {
                          return l10n.errorLettersOnly;
                        }
                        if (trimmed.length < 3) return l10n.errorMin3Chars;
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Account Number Field
                    _buildLabel(l10n.accountNumber, isDark),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _accCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(13),
                        _AccountNumberFormatter(),
                      ],
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF1E1435),
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                      ),
                      decoration: _inputDecoration(
                        hint: '1000 1234 56789',
                        isDark: isDark,
                      ),
                      validator: (v) {
                        final digits = (v ?? '').replaceAll(RegExp(r'\s+'), '');
                        if (digits.isEmpty) return l10n.errorAccountNumberRequired;
                        // Strict validation of exactly 13 digits (numeric only, regex: ^\d{13}$)
                        if (!RegExp(r'^\d{13}$').hasMatch(digits)) {
                          return l10n.errorAccountNumber13Digits;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),

                    // Account Type Radio Selector
                    _buildLabel(l10n.accountType, isDark),
                    const SizedBox(height: 8),
                    _CleanRadioOption(
                      title: l10n.savingAccount,
                      isSelected: provider.accountType == 'Saving Account' ||
                          provider.accountType == 'saving',
                      isDark: isDark,
                      onTap: () => provider.setAccountType('saving'),
                    ),
                    _CleanRadioOption(
                      title: l10n.currentAccount,
                      isSelected: provider.accountType == 'Current Account' ||
                          provider.accountType == 'current',
                      isDark: isDark,
                      onTap: () => provider.setAccountType('current'),
                    ),
                    _CleanRadioOption(
                      title: l10n.specialDemand,
                      isSelected: provider.accountType == 'Special Demand Deposit Account' ||
                          provider.accountType == 'specialDemand',
                      isDark: isDark,
                      onTap: () => provider.setAccountType('specialDemand'),
                    ),

                    // Extra fields for Withdrawal Form matching screenshot
                    if (!_isDeposit) ...[
                      const SizedBox(height: 16),
                      _buildLabel(l10n.birrInFigure, isDark),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _amountFigureCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: TextStyle(
                          color: isDark ? Colors.white : const Color(0xFF1E1435),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: _inputDecoration(hint: '5,000.00', isDark: isDark),
                      ),
                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF280259) : const Color(0xFFFAF5FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? Colors.white.withValues(alpha: 0.15) : const Color(0xFFE9D5FF),
                          ),
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              value: _passbookAccompanied,
                              activeColor: AppColors.deepRoyalPurple,
                              onChanged: (v) =>
                                  setState(() => _passbookAccompanied = v ?? true),
                            ),
                            Expanded(
                              child: Text(
                                l10n.passBookNote,
                                style: TextStyle(
                                  color: isDark ? Colors.white : AppColors.deepRoyalPurple,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Bar with Deep Purple Pill Button
          Container(
            padding: EdgeInsets.fromLTRB(
                20, 12, 20, 12 + MediaQuery.of(context).padding.bottom),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF160036) : Colors.white,
              border: Border(
                top: BorderSide(
                  color: isDark ? Colors.white.withValues(alpha: 0.1) : const Color(0xFFECEBF2),
                ),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _next,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepRoyalPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  l10n.next,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ],
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

  InputDecoration _inputDecoration({
    required String hint,
    Widget? suffixIcon,
    required bool isDark,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFF9CA3AF),
        fontSize: 13,
      ),
      suffixIcon: suffixIcon,
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

class _CleanRadioOption extends StatelessWidget {
  final String title;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _CleanRadioOption({
    required this.title,
    required this.isSelected,
    this.isDark = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isDark
              ? (isSelected ? AppColors.goldAccent.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.05))
              : (isSelected ? const Color(0xFFF5F3FF) : Colors.white),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? AppColors.deepRoyalPurple
                : (isDark ? Colors.white.withValues(alpha: 0.15) : const Color(0xFFE5E7EB)),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              size: 20,
              color: isSelected ? AppColors.deepRoyalPurple : const Color(0xFF9CA3AF),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isDark
                      ? Colors.white
                      : (isSelected ? AppColors.deepRoyalPurple : const Color(0xFF374151)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Formatter to insert space after 4th and 8th digit (e.g. 1000 1234 56789)
class _AccountNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    if (text.length > 13) return oldValue;

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i == 4 || i == 8) {
        buffer.write(' ');
      }
      buffer.write(text[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routing/app_router.dart';
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

  final List<String> _branchSuggestions = [
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

  @override
  void initState() {
    super.initState();
    final p = context.read<FormProvider>();
    _nameCtrl = TextEditingController(
      text: p.accountHolderName.isNotEmpty ? p.accountHolderName : 'Abebe Kebede',
    );
    _accCtrl = TextEditingController(
      text: p.accountNumber.isNotEmpty ? p.accountNumber : '1000 1234 56789',
    );
    _branchCtrl = TextEditingController(
      text: p.branch.isNotEmpty ? p.branch : 'Addis Ababa Main Branch',
    );
    _dateCtrl = TextEditingController(
      text: p.date.isNotEmpty
          ? p.date
          : DateFormat('dd MMM yyyy').format(DateTime.now()),
    );
    _amountFigureCtrl = TextEditingController(
      text: p.totalAmount > 0 ? p.totalAmount.toStringAsFixed(2) : '5,000.00',
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (p.date.isEmpty) p.setDate(_dateCtrl.text);
      if (p.branch.isEmpty) p.setBranch(_branchCtrl.text);
      if (p.accountHolderName.isEmpty) p.setAccountHolderName(_nameCtrl.text);
      if (p.accountNumber.isEmpty) p.setAccountNumber(_accCtrl.text.replaceAll(' ', ''));
    });
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
      final formatted = DateFormat('dd MMM yyyy').format(picked);
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
          p.updateDenomination(200, (amt / 200).floor());
          final rem = amt % 200;
          if (rem >= 100) p.updateDenomination(100, 1);
        }
      }

      context.push(AppRoutes.formStep2);
    }
  }

  bool get _isDeposit =>
      widget.formType == AppConstants.formTypeDeposit ||
      widget.formType.toLowerCase().contains('deposit');

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FormProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FA),
      appBar: AppBar(
        backgroundColor: AppColors.deepRoyalPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          _isDeposit ? 'Fill Deposit Voucher' : 'Fill Withdrawal Form',
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
            child: const StepIndicator(
              currentStep: 1,
              totalSteps: 3,
              stepLabels: ['Account Info', 'Denominations', 'Details'],
            ),
          ),

          // Clean white form body
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Step 1 of 3',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Branch Field
                    _buildLabel('Branch'),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: _branchSuggestions.contains(_branchCtrl.text)
                          ? _branchCtrl.text
                          : _branchSuggestions.first,
                      style: const TextStyle(
                        color: Color(0xFF1E1435),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      dropdownColor: Colors.white,
                      decoration: _inputDecoration(
                        hint: 'Select Branch',
                      ),
                      items: _branchSuggestions.map((b) {
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
                          (v == null || v.isEmpty) ? 'Please select branch' : null,
                    ),
                    const SizedBox(height: 16),

                    // Date Field
                    _buildLabel('Date'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _dateCtrl,
                      readOnly: true,
                      onTap: _pickDate,
                      style: const TextStyle(
                        color: Color(0xFF1E1435),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: _inputDecoration(
                        hint: '21 Jul 2026',
                        suffixIcon: const Icon(Icons.calendar_today_outlined,
                            size: 18, color: Color(0xFF6B7280)),
                      ),
                      validator: (v) => (v == null || v.isEmpty) ? 'Please select date' : null,
                    ),
                    const SizedBox(height: 16),

                    // Account Holder Field
                    _buildLabel('Account Holder (with surname)'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _nameCtrl,
                      textCapitalization: TextCapitalization.words,
                      style: const TextStyle(
                        color: Color(0xFF1E1435),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: _inputDecoration(hint: 'Abebe Kebede'),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Account holder is required';
                        if (v.trim().length < 3) return 'Must be at least 3 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Account Number Field
                    _buildLabel('Account Number'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _accCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(13),
                        _AccountNumberFormatter(),
                      ],
                      style: const TextStyle(
                        color: Color(0xFF1E1435),
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                      ),
                      decoration: _inputDecoration(hint: '1000 1234 567890'),
                      validator: (v) {
                        final digits = v?.replaceAll(' ', '') ?? '';
                        if (digits.isEmpty) return 'Account number is required';
                        if (digits.length != AppConstants.accountNumberLength) {
                          return 'Must be exactly 13 digits';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),

                    // Account Type Radio Selector
                    _buildLabel('Account Type'),
                    const SizedBox(height: 8),
                    _CleanRadioOption(
                      title: 'Saving Account',
                      isSelected: provider.accountType == 'Saving Account',
                      onTap: () => provider.setAccountType('Saving Account'),
                    ),
                    _CleanRadioOption(
                      title: 'Current Account',
                      isSelected: provider.accountType == 'Current Account',
                      onTap: () => provider.setAccountType('Current Account'),
                    ),
                    _CleanRadioOption(
                      title: 'Special Demand Deposit Account',
                      isSelected: provider.accountType == 'Special Demand Deposit Account',
                      onTap: () => provider.setAccountType('Special Demand Deposit Account'),
                    ),

                    // Extra fields for Withdrawal Form matching screenshot
                    if (!_isDeposit) ...[
                      const SizedBox(height: 16),
                      _buildLabel('Birr in Figure'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _amountFigureCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: const TextStyle(
                          color: Color(0xFF1E1435),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: _inputDecoration(hint: '5,000.00'),
                      ),
                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAF5FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE9D5FF)),
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              value: _passbookAccompanied,
                              activeColor: AppColors.deepRoyalPurple,
                              onChanged: (v) =>
                                  setState(() => _passbookAccompanied = v ?? true),
                            ),
                            const Expanded(
                              child: Text(
                                'Pass book must accompany this form',
                                style: TextStyle(
                                  color: AppColors.deepRoyalPurple,
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
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFECEBF2))),
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
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF374151),
      ),
    );
  }

  static InputDecoration _inputDecoration({required String hint, Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.deepRoyalPurple, width: 1.5),
      ),
    );
  }
}

// ── Clean Radio Option matching screenshot ───────────────────────────────────
class _CleanRadioOption extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _CleanRadioOption({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.deepRoyalPurple
                      : const Color(0xFF9CA3AF),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.deepRoyalPurple,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: const Color(0xFF1F2937),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue old, TextEditingValue newVal) {
    final digits = newVal.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i == 4 || i == 8) buffer.write(' ');
      buffer.write(digits[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

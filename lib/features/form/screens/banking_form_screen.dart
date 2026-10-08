import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routing/app_router.dart';
import '../../../shared/widgets/cbe_logo.dart';
import '../../../shared/widgets/glass_card.dart';
import '../providers/form_provider.dart';

class BankingFormScreen extends StatefulWidget {
  final String formType;

  const BankingFormScreen({
    super.key,
    this.formType = 'Cash Deposit',
  });

  @override
  State<BankingFormScreen> createState() => _BankingFormScreenState();
}

class _BankingFormScreenState extends State<BankingFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _branchController;
  late TextEditingController _dateController;
  late TextEditingController _accountHolderController;
  late TextEditingController _accountNumberController;
  late TextEditingController _amountController;
  late TextEditingController _depositorController;
  late TextEditingController _phoneController;

  bool _isSubmitting = false;

  final List<String> _branchSuggestions = [
    'አዲስ አበባ ዋና ቅርንጫፍ (Addis Ababa Main)',
    'ፊንፊኔ ቅርንጫፍ (Finfine Branch)',
    'ቦሌ ቅርንጫፍ (Bole Branch)',
    'መገናኛ ቅርንጫፍ (Megenagna Branch)',
    'ፒያሳ ቅርንጫፍ (Piazza Branch)',
    'ሳርቤት ቅርንጫፍ (Sarbet Branch)',
    'ቄራ ቅርንጫፍ (Kera Branch)',
    'ሀዋሳ ቅርንጫፍ (Hawassa Branch)',
    'ባህር ዳር ቅርንጫፍ (Bahir Dar Branch)',
    'አዳማ ቅርንጫፍ (Adama Branch)',
  ];

  @override
  void initState() {
    super.initState();
    final p = context.read<FormProvider>();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    _branchController = TextEditingController(
      text: p.branch.isNotEmpty ? p.branch : 'አዲስ አበባ ዋና ቅርንጫፍ',
    );
    _dateController = TextEditingController(
      text: p.date.isNotEmpty ? p.date : today,
    );
    _accountHolderController = TextEditingController(text: p.accountHolderName);
    _accountNumberController = TextEditingController(text: p.accountNumber);
    _amountController = TextEditingController(
      text: p.totalAmount > 0 ? p.totalAmount.toStringAsFixed(2) : '',
    );
    _depositorController = TextEditingController(text: p.depositedBy);
    _phoneController = TextEditingController(text: p.phoneNumber);
  }

  @override
  void dispose() {
    _branchController.dispose();
    _dateController.dispose();
    _accountHolderController.dispose();
    _accountNumberController.dispose();
    _amountController.dispose();
    _depositorController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.goldAccent,
              onPrimary: AppColors.deepRoyalPurple,
              surface: AppColors.royalPurpleMedium,
              onSurface: AppColors.crispWhite,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: AppColors.deepRoyalPurple,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formatted = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {
        _dateController.text = formatted;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final p = context.read<FormProvider>();
      p.setBranch(_branchController.text.trim());
      p.setDate(_dateController.text.trim());
      p.setAccountHolderName(_accountHolderController.text.trim());
      p.setAccountNumber(_accountNumberController.text.trim());
      p.setFormType(widget.formType);

      final amt = double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0.0;
      if (amt > 0) {
        p.updateDenomination(100, (amt / 100).floor());
      }
      if (_depositorController.text.isNotEmpty) {
        p.setDepositedBy(_depositorController.text.trim());
      }
      if (_phoneController.text.isNotEmpty) {
        p.setPhoneNumber(_phoneController.text.trim());
      }

      // Generate transaction and encrypted QR code
      await p.generateTransaction();

      if (mounted) {
        context.push(AppRoutes.qrCode);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ስህተት ተከስቷል: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.purpleBackgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar with Dynamic CBE Logo
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: AppColors.crispWhite, size: 20),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'የባንክ ቅጽ መሙያ',
                            style: TextStyle(
                              color: AppColors.crispWhite,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'CBE Digital Form Service',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const CbeLogo(size: 44),
                  ],
                ),
              ),

              // Form content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Service Type Indicator
                        GlassCard(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          borderColor: AppColors.goldAccent.withValues(alpha: 0.3),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: AppColors.goldGradient,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.edit_document,
                                  color: AppColors.deepRoyalPurple,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.formType == 'Cash Deposit'
                                          ? 'የገንዘብ ማስቀመጫ ቅጽ'
                                          : widget.formType == 'Cash Withdrawal'
                                              ? 'የገንዘብ ማውጫ ቅጽ'
                                              : widget.formType,
                                      style: const TextStyle(
                                        color: AppColors.crispWhite,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const Text(
                                      'እባክዎ መረጃዎቹን በጥንቃቄ ይሙሉ',
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Form Fields in Glassmorphic Container
                        GlassCard(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 1. ቅርንጫፍ (Branch)
                              _buildFieldLabel('ቅርንጫፍ', isRequired: true),
                              const SizedBox(height: 8),
                              Autocomplete<String>(
                                initialValue:
                                    TextEditingValue(text: _branchController.text),
                                optionsBuilder: (TextEditingValue textVal) {
                                  if (textVal.text.isEmpty) {
                                    return _branchSuggestions;
                                  }
                                  return _branchSuggestions.where((s) => s
                                      .toLowerCase()
                                      .contains(textVal.text.toLowerCase()));
                                },
                                onSelected: (String sel) {
                                  _branchController.text = sel;
                                },
                                fieldViewBuilder:
                                    (context, controller, focusNode, onFieldSubmitted) {
                                  _branchController = controller;
                                  return TextFormField(
                                    controller: controller,
                                    focusNode: focusNode,
                                    style: const TextStyle(
                                        color: AppColors.crispWhite, fontSize: 15),
                                    decoration: InputDecoration(
                                      hintText: 'ቅርንጫፍ ይምረጡ ወይም ይፃፉ',
                                      prefixIcon: const Icon(Icons.account_balance,
                                          color: AppColors.goldAccent, size: 20),
                                      suffixIcon: const Icon(
                                          Icons.arrow_drop_down,
                                          color: AppColors.textSecondary),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    validator: (v) => (v == null || v.trim().isEmpty)
                                        ? 'እባክዎ ቅርንጫፍ ያስገቡ'
                                        : null,
                                  );
                                },
                              ),
                              const SizedBox(height: 18),

                              // 2. ቀን (Date)
                              _buildFieldLabel('ቀን', isRequired: true),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _dateController,
                                readOnly: true,
                                onTap: _pickDate,
                                style: const TextStyle(
                                    color: AppColors.crispWhite, fontSize: 15),
                                decoration: InputDecoration(
                                  hintText: 'ቀን ይምረጡ (YYYY-MM-DD)',
                                  prefixIcon: const Icon(Icons.calendar_today,
                                      color: AppColors.goldAccent, size: 20),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.edit_calendar_rounded,
                                        color: AppColors.goldAccent, size: 20),
                                    onPressed: _pickDate,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (v) => (v == null || v.trim().isEmpty)
                                    ? 'እባክዎ ቀን ያስገቡ'
                                    : null,
                              ),
                              const SizedBox(height: 18),

                              // 3. የሒሳብ ባለቤት ስም (Account Holder Name)
                              _buildFieldLabel('የሒሳብ ባለቤት ስም', isRequired: true),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _accountHolderController,
                                style: const TextStyle(
                                    color: AppColors.crispWhite, fontSize: 15),
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                  hintText: 'የሙሉ ስም ያስገቡ (አበበ በቀለ ከበደ)',
                                  prefixIcon: const Icon(Icons.person_rounded,
                                      color: AppColors.goldAccent, size: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (v) => (v == null || v.trim().isEmpty)
                                    ? 'እባክዎ የሒሳብ ባለቤት ስም ያስገቡ'
                                    : null,
                              ),
                              const SizedBox(height: 18),

                              // 4. የሒሳብ ቍጥር (Account Number)
                              _buildFieldLabel('የሒሳብ ቍጥር', isRequired: true),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _accountNumberController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(13),
                                ],
                                style: const TextStyle(
                                  color: AppColors.crispWhite,
                                  fontSize: 16,
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: InputDecoration(
                                  hintText: '1000XXXXXXXXX (13 አሃዝ)',
                                  prefixIcon: const Icon(Icons.numbers_rounded,
                                      color: AppColors.goldAccent, size: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'እባክዎ የሒሳብ ቍጥር ያስገቡ';
                                  }
                                  if (v.trim().length < 10) {
                                    return 'ትክክለኛ የባንክ ሒሳብ ቁጥር ያስገቡ';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 18),

                              // 5. የገንዘብ መጠን (Amount in ETB)
                              _buildFieldLabel('የገንዘብ መጠን (ETB)', isRequired: true),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _amountController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(decimal: true),
                                style: const TextStyle(
                                  color: AppColors.crispWhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                                decoration: InputDecoration(
                                  hintText: '0.00 ብር',
                                  prefixIcon: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 14),
                                    child: Text(
                                      'ETB',
                                      style: TextStyle(
                                        color: AppColors.goldAccent,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'እባክዎ የገንዘብ መጠን ያስገቡ';
                                  }
                                  final n = double.tryParse(v.replaceAll(',', ''));
                                  if (n == null || n <= 0) {
                                    return 'ትክክለኛ መጠን ያስገቡ';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 18),

                              // 6. አስቀማጭ ስም (Depositor / Withdrawer)
                              _buildFieldLabel('የአስቀማጭ/አውጪ ስም (አማራጭ)'),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _depositorController,
                                style: const TextStyle(
                                    color: AppColors.crispWhite, fontSize: 15),
                                decoration: InputDecoration(
                                  hintText: 'የተለየ ከሆነ ስም ያስገቡ',
                                  prefixIcon: const Icon(Icons.badge_outlined,
                                      color: AppColors.textSecondary, size: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),

                              // 7. ስልክ ቁጥር (Phone Number)
                              _buildFieldLabel('ስልክ ቁጥር (አማራጭ)'),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                style: const TextStyle(
                                    color: AppColors.crispWhite, fontSize: 15),
                                decoration: InputDecoration(
                                  hintText: '09XXXXXXXX',
                                  prefixIcon: const Icon(Icons.phone_android_rounded,
                                      color: AppColors.textSecondary, size: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Submit Button "አብቅት"
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.goldAccent,
                              foregroundColor: AppColors.deepRoyalPurple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 6,
                              shadowColor: AppColors.goldAccent.withValues(alpha: 0.4),
                            ),
                            child: _isSubmitting
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          AppColors.deepRoyalPurple),
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'አብቅት',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(Icons.arrow_forward_rounded, size: 22),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String text, {bool isRequired = false}) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            color: AppColors.crispWhite,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (isRequired)
          const Text(
            ' *',
            style: TextStyle(
              color: AppColors.goldAccent,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }
}

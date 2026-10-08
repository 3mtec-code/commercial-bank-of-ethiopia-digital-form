import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routing/app_router.dart';
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

  String? _selectedSource;
  late SignatureController _signatureController;
  bool _signatureError = false;

  final List<String> _sources = [
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
          : 'Two Thousand Six Hundred Thirty Birr Only',
    );
    _phoneCtrl = TextEditingController(
      text: p.phoneNumber.isNotEmpty ? p.phoneNumber : '09 12 34 56 78',
    );
    _personCtrl = TextEditingController(
      text: p.depositedBy.isNotEmpty
          ? p.depositedBy
          : (p.accountHolderName.isNotEmpty ? p.accountHolderName : 'Abebe Kebede'),
    );
    _selectedSource = p.sourceOfProceeds.isNotEmpty ? p.sourceOfProceeds : 'Salary';

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

  Future<void> _goToReview() async {
    if (!_formKey.currentState!.validate()) return;

    if (_signatureController.isEmpty &&
        context.read<FormProvider>().signatureBytes == null) {
      setState(() => _signatureError = true);
    } else {
      setState(() => _signatureError = false);
    }

    final p = context.read<FormProvider>();
    p.setAmountInWords(_amountWordsCtrl.text.trim());
    p.setSourceOfProceeds(_selectedSource ?? 'Salary');
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
        title: const Text(
          'Other Details',
          style: TextStyle(
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
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Step 3 of 3',
                    style: TextStyle(
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
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
                        _buildLabel('Amount in Words'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _amountWordsCtrl,
                          maxLines: 2,
                          style: const TextStyle(
                            color: Color(0xFF1E1435),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: _inputDecoration(
                            hint: 'Two Thousand Six Hundred Thirty Birr Only',
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Please enter amount in words'
                              : null,
                        ),
                        const SizedBox(height: 16),

                        // Source of Proceeds Dropdown
                        _buildLabel('Source of Proceeds'),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedSource,
                          style: const TextStyle(
                            color: Color(0xFF1E1435),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          dropdownColor: Colors.white,
                          decoration: _inputDecoration(hint: 'Select source'),
                          items: _sources.map((s) {
                            return DropdownMenuItem(
                              value: s,
                              child: Text(s),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() => _selectedSource = val);
                          },
                        ),
                        const SizedBox(height: 16),

                        // Telephone Number
                        _buildLabel('Telephone Number'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _phoneCtrl,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(
                            color: Color(0xFF1E1435),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: _inputDecoration(
                            hint: '09 12 34 56 78',
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Please enter phone number'
                              : null,
                        ),
                        const SizedBox(height: 16),

                        // Deposited By
                        _buildLabel('Deposited By'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _personCtrl,
                          style: const TextStyle(
                            color: Color(0xFF1E1435),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: _inputDecoration(
                            hint: 'Abebe Kebede',
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Please enter depositor name'
                              : null,
                        ),
                        const SizedBox(height: 18),

                        // Deposited By Signature
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildLabel('Deposited By Signature'),
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
                              child: const Text(
                                'Clear',
                                style: TextStyle(
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
                            color: const Color(0xFFFAFAFA),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _signatureError
                                  ? AppColors.error
                                  : const Color(0xFFE5E7EB),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Signature(
                              controller: _signatureController,
                              backgroundColor: const Color(0xFFFAFAFA),
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
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
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
                          foregroundColor: const Color(0xFF1E1435),
                          side: const BorderSide(color: Color(0xFFD1D5DB)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Back',
                          style: TextStyle(
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
                        child: const Text(
                          'Review',
                          style: TextStyle(
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF374151),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFF9CA3AF),
        fontSize: 13,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.deepRoyalPurple, width: 1.5),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routing/app_router.dart';
import '../../../features/form/providers/form_provider.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FormProvider>();

    final branch = provider.branch.isNotEmpty
        ? provider.branch
        : 'Addis Ababa Main Branch';
    final date = provider.date.isNotEmpty ? provider.date : '21 Jul 2026';
    final accountHolder = provider.accountHolderName.isNotEmpty
        ? provider.accountHolderName
        : 'Abebe Kebede';
    final accountNumber = provider.accountNumber.isNotEmpty
        ? provider.accountNumber
        : '1000 1234 567890';
    final accountType = provider.accountType.isNotEmpty
        ? provider.accountType
        : 'Saving Account';
    final totalAmount = provider.totalAmount > 0 ? provider.totalAmount : 5000.0;
    final amountInWords = provider.amountInWords.isNotEmpty
        ? provider.amountInWords
        : 'Five Thousand Birr Only';

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
          'Review Your Form',
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
            // Top Subtitle
            Container(
              width: double.infinity,
              color: AppColors.deepRoyalPurple,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Step 2 of 3',
                    style: TextStyle(
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
                      _buildReviewRow(
                        icon: Icons.account_balance_outlined,
                        label: 'Branch',
                        value: branch,
                      ),
                      const Divider(color: Color(0xFFF3F4F6), height: 24),

                      _buildReviewRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'Date',
                        value: date,
                      ),
                      const Divider(color: Color(0xFFF3F4F6), height: 24),

                      _buildReviewRow(
                        icon: Icons.person_outline_rounded,
                        label: 'Account Holder',
                        value: accountHolder,
                      ),
                      const Divider(color: Color(0xFFF3F4F6), height: 24),

                      _buildReviewRow(
                        icon: Icons.credit_card_rounded,
                        label: 'Account Number',
                        value: accountNumber,
                      ),
                      const Divider(color: Color(0xFFF3F4F6), height: 24),

                      _buildReviewRow(
                        icon: Icons.account_circle_outlined,
                        label: 'Account Type',
                        value: accountType,
                      ),
                      const Divider(color: Color(0xFFF3F4F6), height: 24),

                      _buildReviewRow(
                        icon: Icons.monetization_on_outlined,
                        label: 'Amount (Figure)',
                        value: '${_formatAmount(totalAmount)} ETB',
                        isHighlighted: true,
                      ),
                      const Divider(color: Color(0xFFF3F4F6), height: 24),

                      _buildReviewRow(
                        icon: Icons.notes_rounded,
                        label: 'Amount (Words)',
                        value: amountInWords,
                      ),

                      // Signature thumbnail if present
                      if (provider.signatureBytes != null) ...[
                        const Divider(color: Color(0xFFF3F4F6), height: 24),
                        const Text(
                          'Signature',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFAFAFA),
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
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
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
                          foregroundColor: const Color(0xFF1E1435),
                          side: const BorderSide(color: Color(0xFFD1D5DB)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Edit',
                          style: TextStyle(
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
                        child: const Text(
                          'Confirm',
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

  Widget _buildReviewRow({
    required IconData icon,
    required String label,
    required String value,
    bool isHighlighted = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF6B7280)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: isHighlighted ? 15 : 14,
                  fontWeight: isHighlighted ? FontWeight.w800 : FontWeight.w600,
                  color: isHighlighted
                      ? AppColors.deepRoyalPurple
                      : const Color(0xFF1E1435),
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
}

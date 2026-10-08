import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routing/app_router.dart';
import '../providers/form_provider.dart';

class FormStep2Screen extends StatelessWidget {
  const FormStep2Screen({super.key});

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
        title: const Text(
          'Denominations',
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
            // Top Stepper Indicator Subtitle
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

            // Denominations Table Card
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                child: Container(
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
                    children: [
                      // Header Row
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          border: Border(
                            bottom: BorderSide(color: Color(0xFFE5E7EB)),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text(
                                'Denomination (ETB)',
                                style: TextStyle(
                                  color: Color(0xFF4B5563),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Center(
                                child: Text(
                                  'Quantity',
                                  style: TextStyle(
                                    color: Color(0xFF4B5563),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Amount',
                                  style: TextStyle(
                                    color: Color(0xFF4B5563),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Denomination Rows
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: AppConstants.denominations.length,
                        separatorBuilder: (_, __) => const Divider(
                          color: Color(0xFFF3F4F6),
                          height: 1,
                        ),
                        itemBuilder: (context, index) {
                          final denom = AppConstants.denominations[index];
                          return _DenominationRow(denomination: denom);
                        },
                      ),

                      // Total Row matching image
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                          border: Border(
                            top: BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                color: Color(0xFF1E1435),
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              _formatNumber(provider.totalAmount),
                              style: const TextStyle(
                                color: AppColors.deepRoyalPurple,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Next Button
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (provider.totalAmount <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter at least one denomination (እባክዎ የብር መጠን ያስገቡ)'),
                          backgroundColor: AppColors.error,
                        ),
                      );
                      return;
                    }
                    context.push(AppRoutes.formStep3);
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
                    'Next',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatNumber(double amount) {
    return amount.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}

class _DenominationRow extends StatelessWidget {
  final double denomination;
  const _DenominationRow({required this.denomination});

  String _formatDenom(double d) {
    if (d >= 1) return '${d.toStringAsFixed(0)} x';
    return '${d.toStringAsFixed(2)} x';
  }

  String _formatAmount(double amt) {
    return amt.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FormProvider>();
    final qty = provider.denominationQty[denomination] ?? 0;
    final lineTotal = denomination * qty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Denomination Label: "200 x"
          Expanded(
            flex: 4,
            child: Text(
              _formatDenom(denomination),
              style: const TextStyle(
                color: Color(0xFF1E1435),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // Stepper: "-" "qty" "+"
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStepBtn(
                  icon: Icons.remove,
                  onPressed: qty > 0
                      ? () => provider.updateDenomination(denomination, qty - 1)
                      : null,
                ),
                Container(
                  constraints: const BoxConstraints(minWidth: 32),
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    '$qty',
                    style: const TextStyle(
                      color: Color(0xFF1E1435),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                _buildStepBtn(
                  icon: Icons.add,
                  onPressed: () =>
                      provider.updateDenomination(denomination, qty + 1),
                ),
              ],
            ),
          ),

          // Line Total Amount
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                _formatAmount(lineTotal),
                style: const TextStyle(
                  color: Color(0xFF1E1435),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepBtn({required IconData icon, VoidCallback? onPressed}) {
    return SizedBox(
      width: 28,
      height: 28,
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: 16,
        style: IconButton.styleFrom(
          backgroundColor: const Color(0xFFF3F4F6),
          foregroundColor: const Color(0xFF4B5563),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        icon: Icon(icon),
        onPressed: onPressed,
      ),
    );
  }
}

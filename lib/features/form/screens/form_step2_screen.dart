import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routing/app_router.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/form_provider.dart';

class FormStep2Screen extends StatefulWidget {
  const FormStep2Screen({super.key});

  @override
  State<FormStep2Screen> createState() => _FormStep2ScreenState();
}

class _FormStep2ScreenState extends State<FormStep2Screen> {
  late TextEditingController _customAmountCtrl;

  @override
  void initState() {
    super.initState();
    final p = context.read<FormProvider>();
    _customAmountCtrl = TextEditingController(
      text: p.totalAmount > 0 ? p.totalAmount.toStringAsFixed(0) : '',
    );
  }

  @override
  void dispose() {
    _customAmountCtrl.dispose();
    super.dispose();
  }

  final List<double> _presets = [100, 500, 1000, 5000, 10000, 25000];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<FormProvider>();
    final isDark = provider.isDarkMode;
    final isAmharic = provider.locale.languageCode == 'am';

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
          l10n.stepDenominations,
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
            // Top Stepper Indicator Subtitle
            Container(
              width: double.infinity,
              color: AppColors.deepRoyalPurple,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.step2Of3,
                    style: const TextStyle(
                      color: Color(0xFFD4C8E8),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                child: Column(
                  children: [
                    // 2 Selectable Options Segmented Tab
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1D0047) : const Color(0xFFECEBF2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          // Option 1: Quick Preset Amounts
                          Expanded(
                            child: InkWell(
                              onTap: () => provider.setDenominationInputMode(0),
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: provider.denominationInputMode == 0
                                      ? (isDark ? AppColors.royalPurpleMedium : Colors.white)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: provider.denominationInputMode == 0
                                      ? [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.05),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Text(
                                  l10n.quickPresetAmounts,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: provider.denominationInputMode == 0
                                        ? FontWeight.w800
                                        : FontWeight.w600,
                                    color: provider.denominationInputMode == 0
                                        ? (isDark ? AppColors.goldAccent : AppColors.deepRoyalPurple)
                                        : (isDark ? const Color(0xFFB8A9D4) : const Color(0xFF6B7280)),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Option 2: Manual Custom Entry
                          Expanded(
                            child: InkWell(
                              onTap: () => provider.setDenominationInputMode(1),
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: provider.denominationInputMode == 1
                                      ? (isDark ? AppColors.royalPurpleMedium : Colors.white)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: provider.denominationInputMode == 1
                                      ? [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.05),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Text(
                                  l10n.manualCustomEntry,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: provider.denominationInputMode == 1
                                        ? FontWeight.w800
                                        : FontWeight.w600,
                                    color: provider.denominationInputMode == 1
                                        ? (isDark ? AppColors.goldAccent : AppColors.deepRoyalPurple)
                                        : (isDark ? const Color(0xFFB8A9D4) : const Color(0xFF6B7280)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Display Content Based on Option Selected
                    if (provider.denominationInputMode == 0) ...[
                      // Option 1: Quick Preset Amounts Grid
                      Container(
                        padding: const EdgeInsets.all(16),
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
                            Text(
                              l10n.quickPresetAmounts,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : const Color(0xFF1E1435),
                              ),
                            ),
                            const SizedBox(height: 14),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 1.8,
                              ),
                              itemCount: _presets.length,
                              itemBuilder: (ctx, i) {
                                final amount = _presets[i];
                                final isSelected = provider.totalAmount == amount;

                                return InkWell(
                                  onTap: () {
                                    provider.setPresetAmount(amount);
                                    _customAmountCtrl.text = amount.toStringAsFixed(0);
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.deepRoyalPurple
                                          : (isDark
                                              ? Colors.white.withValues(alpha: 0.05)
                                              : const Color(0xFFF9FAFB)),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.deepRoyalPurple
                                            : (isDark
                                                ? Colors.white.withValues(alpha: 0.15)
                                                : const Color(0xFFE5E7EB)),
                                        width: isSelected ? 1.8 : 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${_formatAmount(amount)} ${isAmharic ? "ብር" : "ETB"}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: isSelected
                                              ? AppColors.goldAccent
                                              : (isDark
                                                  ? Colors.white
                                                  : const Color(0xFF1E1435)),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Option 2 or Cash Breakdown Table
                    Container(
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
                          if (provider.denominationInputMode == 1) ...[
                            // Manual Custom Amount Entry Field
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.customAmount,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? Colors.white : const Color(0xFF374151),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _customAmountCtrl,
                                          keyboardType: const TextInputType.numberWithOptions(
                                              decimal: true),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'^\d+\.?\d{0,2}')),
                                          ],
                                          style: TextStyle(
                                            color: isDark ? Colors.white : const Color(0xFF1E1435),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: l10n.enterAmountHint,
                                            suffixText: isAmharic ? 'ብር' : 'ETB',
                                            contentPadding: const EdgeInsets.symmetric(
                                                horizontal: 14, vertical: 12),
                                            filled: true,
                                            fillColor: isDark
                                                ? Colors.white.withValues(alpha: 0.08)
                                                : const Color(0xFFFAFAFA),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                                            ),
                                          ),
                                          onChanged: (val) {
                                            final amt = double.tryParse(val) ?? 0.0;
                                            provider.setManualAmount(amt);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    l10n.denominationBreakdown,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? AppColors.goldAccent : AppColors.deepRoyalPurple,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          // Header Row
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.05)
                                  : const Color(0xFFF9FAFB),
                              borderRadius: provider.denominationInputMode == 0
                                  ? const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    )
                                  : null,
                              border: Border(
                                bottom: BorderSide(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.1)
                                      : const Color(0xFFE5E7EB),
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    l10n.denominationHeader,
                                    style: TextStyle(
                                      color: isDark
                                          ? const Color(0xFFD4C8E8)
                                          : const Color(0xFF4B5563),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Center(
                                    child: Text(
                                      l10n.quantityHeader,
                                      style: TextStyle(
                                        color: isDark
                                            ? const Color(0xFFD4C8E8)
                                            : const Color(0xFF4B5563),
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
                                      l10n.amountHeader,
                                      style: TextStyle(
                                        color: isDark
                                            ? const Color(0xFFD4C8E8)
                                            : const Color(0xFF4B5563),
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
                            separatorBuilder: (_, __) => Divider(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.06)
                                  : const Color(0xFFF3F4F6),
                              height: 1,
                            ),
                            itemBuilder: (context, index) {
                              final denom = AppConstants.denominations[index];
                              return _DenominationRow(
                                denomination: denom,
                                isDark: isDark,
                                onQtyChanged: () {
                                  _customAmountCtrl.text =
                                      provider.totalAmount.toStringAsFixed(0);
                                },
                              );
                            },
                          ),

                          // Total Row
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.08)
                                  : const Color(0xFFF9FAFB),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                              border: Border(
                                top: BorderSide(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.15)
                                      : const Color(0xFFE5E7EB),
                                  width: 1.5,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  l10n.total,
                                  style: TextStyle(
                                    color: isDark ? Colors.white : const Color(0xFF1E1435),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  '${_formatAmount(provider.totalAmount)} ${isAmharic ? "ብር" : "ETB"}',
                                  style: TextStyle(
                                    color: isDark ? AppColors.goldAccent : AppColors.deepRoyalPurple,
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
                  ],
                ),
              ),
            ),

            // Bottom Next Button
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
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (provider.totalAmount <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.errorEnterDenomination),
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
                  child: Text(
                    l10n.next,
                    style: const TextStyle(
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

  static String _formatAmount(double amount) {
    return amount.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}

class _DenominationRow extends StatelessWidget {
  final double denomination;
  final bool isDark;
  final VoidCallback onQtyChanged;

  const _DenominationRow({
    required this.denomination,
    required this.isDark,
    required this.onQtyChanged,
  });

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
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF1E1435),
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
                      ? () {
                          provider.updateDenomination(denomination, qty - 1);
                          onQtyChanged();
                        }
                      : null,
                ),
                Container(
                  constraints: const BoxConstraints(minWidth: 32),
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    '$qty',
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF1E1435),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                _buildStepBtn(
                  icon: Icons.add,
                  onPressed: () {
                    provider.updateDenomination(denomination, qty + 1);
                    onQtyChanged();
                  },
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
                style: TextStyle(
                  color: isDark ? const Color(0xFFD4C8E8) : const Color(0xFF1E1435),
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
          backgroundColor: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : const Color(0xFFF3F4F6),
          foregroundColor: isDark ? Colors.white : const Color(0xFF4B5563),
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

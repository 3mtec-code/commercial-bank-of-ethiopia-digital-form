import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routing/app_router.dart';
import '../../../features/form/providers/form_provider.dart';

class TellerVerifyScreen extends StatefulWidget {
  final Map<String, dynamic> payload;
  const TellerVerifyScreen({super.key, required this.payload});

  @override
  State<TellerVerifyScreen> createState() => _TellerVerifyScreenState();
}

class _TellerVerifyScreenState extends State<TellerVerifyScreen> {
  bool _isProcessing = false;
  String _currentStatus = 'Pending';

  @override
  void initState() {
    super.initState();
    _currentStatus = (widget.payload['status'] ?? 'Pending').toString();
  }

  Map<String, dynamic> get p => widget.payload;

  String _get(String key) => (p[key] ?? '').toString();

  Future<void> _processTransaction() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 700));

    final id = _get('id');
    if (id.isNotEmpty && mounted) {
      await context.read<FormProvider>().updateTransactionStatus(id, 'completed');
    }

    if (mounted) {
      setState(() {
        _isProcessing = false;
        _currentStatus = 'Completed';
      });

      // Show success modal
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          title: const Column(
            children: [
              Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 54),
              SizedBox(height: 12),
              Text(
                'Transaction Processed!',
                style: TextStyle(
                  color: Color(0xFF1E1435),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Text(
            'Reference: ${_get('referenceNumber')}\nTransaction has been successfully approved and credited.',
            style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13),
            textAlign: TextAlign.center,
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  context.go(AppRoutes.home);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepRoyalPurple,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text('Return to Home',
                    style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final refNumber = _get('referenceNumber').isNotEmpty
        ? _get('referenceNumber')
        : 'TXN-20260721-000123';
    final formType = _get('formType').isNotEmpty
        ? _get('formType')
        : 'Cash Deposit Voucher';
    final customer = _get('accountHolderName').isNotEmpty
        ? _get('accountHolderName')
        : 'Abebe Kebede';
    final accountNumber = _get('accountNumber').isNotEmpty
        ? _get('accountNumber')
        : '1000 1234 567890';
    final amount = _get('totalAmount').isNotEmpty
        ? '${_get('totalAmount')} ETB'
        : '5,000.00 ETB';

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
          'Form Details',
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
                      // Verified Badge Row at top right
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFA7F3D0)),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle_rounded,
                                    size: 14, color: Color(0xFF10B981)),
                                SizedBox(width: 4),
                                Text(
                                  'Verified',
                                  style: TextStyle(
                                    color: Color(0xFF10B981),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      _buildDetailRow('Reference Number', refNumber),
                      const Divider(color: Color(0xFFF3F4F6), height: 24),

                      _buildDetailRow('Form Type', formType),
                      const Divider(color: Color(0xFFF3F4F6), height: 24),

                      _buildDetailRow('Customer', customer),
                      const Divider(color: Color(0xFFF3F4F6), height: 24),

                      _buildDetailRow('Account Number', accountNumber),
                      const Divider(color: Color(0xFFF3F4F6), height: 24),

                      _buildDetailRow('Amount', amount, isBold: true),
                      const Divider(color: Color(0xFFF3F4F6), height: 24),

                      _buildDetailRow('Status', _currentStatus,
                          statusColor: _currentStatus == 'Completed'
                              ? const Color(0xFF10B981)
                              : const Color(0xFFD97706)),
                    ],
                  ),
                ),
              ),
            ),

            // Proceed Pill Button at Bottom
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
                  onPressed: _isProcessing ? null : _processTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deepRoyalPurple,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: _isProcessing
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Proceed',
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

  Widget _buildDetailRow(String label, String value,
      {bool isBold = false, Color? statusColor}) {
    return Column(
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
            fontSize: isBold ? 15 : 14,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: statusColor ?? const Color(0xFF1E1435),
          ),
        ),
      ],
    );
  }
}

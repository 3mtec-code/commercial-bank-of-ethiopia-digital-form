import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../features/form/providers/form_provider.dart';
import '../../../shared/widgets/cbe_logo.dart';

class TellerScanScreen extends StatefulWidget {
  final bool embedded;
  const TellerScanScreen({super.key, this.embedded = false});

  @override
  State<TellerScanScreen> createState() => _TellerScanScreenState();
}

class _TellerScanScreenState extends State<TellerScanScreen>
    with SingleTickerProviderStateMixin {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );

  bool _hasScanned = false;
  bool _torchOn = false;

  late AnimationController _scanAnim;
  late Animation<double> _scanLine;

  @override
  void initState() {
    super.initState();
    _scanAnim = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _scanLine = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _scanAnim, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scanAnim.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_hasScanned) return;
    final code = capture.barcodes.firstOrNull?.rawValue;
    if (code == null || code.isEmpty) return;

    setState(() => _hasScanned = true);
    _controller.stop();

    _processQrCode(code);
  }

  void _processQrCode(String code) {
    // Attempt to decrypt the payload
    final payload = FormProvider.decryptPayload(code);
    if (payload == null) {
      _showError('Invalid or unreadable CBE QR code.');
      return;
    }

    // Check expiry
    try {
      final expiresAt = DateTime.parse(payload['expiresAt'] as String);
      if (DateTime.now().isAfter(expiresAt)) {
        _showError('This QR code has expired. Customer must generate a new one.');
        return;
      }
    } catch (_) {
      // Continue if date format is custom
    }

    context.push('/teller/verify', extra: payload);
  }

  void _simulateScan() {
    final p = context.read<FormProvider>();
    final tx = p.currentTransaction;
    if (tx != null && p.generatedQrData.isNotEmpty) {
      _processQrCode(p.generatedQrData);
    } else {
      // Demo payload matching diagram
      final demoPayload = {
        'referenceNumber': 'TXN-20260721-000123',
        'formType': 'Cash Deposit Voucher',
        'accountHolderName': 'Abebe Kebede',
        'accountNumber': '1000 1234 567890',
        'accountType': 'Saving Account',
        'branch': 'Addis Ababa Main Branch',
        'date': '21 Jul 2026',
        'totalAmount': 5000.0,
        'amountInWords': 'Five Thousand Birr Only',
        'sourceOfProceeds': 'Business',
        'phoneNumber': '09 12 34 56 78',
        'depositedBy': 'Abebe Kebede',
        'status': 'Pending',
        'expiresAt': DateTime.now().add(const Duration(minutes: 5)).toIso8601String(),
        'denominations': {'200': 20, '100': 10},
      };
      context.push('/teller/verify', extra: demoPayload);
    }
  }

  void _showError(String msg) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.royalPurpleMedium,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.error_outline_rounded, color: AppColors.error),
            SizedBox(width: 8),
            Text('Scan Failed', style: TextStyle(color: AppColors.crispWhite)),
          ],
        ),
        content: Text(msg, style: const TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _hasScanned = false);
              _controller.start();
            },
            child: const Text('Try Again', style: TextStyle(color: AppColors.goldAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),

          // Scan Overlay
          _ScanOverlay(scanLine: _scanLine),

          // Top Header
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!widget.embedded && Navigator.canPop(context))
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 20),
                      onPressed: () => context.pop(),
                    )
                  else
                    const SizedBox(width: 40),
                  const Row(
                    children: [
                      CbeLogo(size: 36),
                      SizedBox(width: 10),
                      Text(
                        'Scan QR Code',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      _torchOn ? Icons.flashlight_on_rounded : Icons.flashlight_off_rounded,
                      color: _torchOn ? AppColors.goldAccent : Colors.white,
                    ),
                    onPressed: () {
                      _controller.toggleTorch();
                      setState(() => _torchOn = !_torchOn);
                    },
                  ),
                ],
              ),
            ),
          ),

          // Bottom Controls & Simulation Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  24, 20, 24, 24 + MediaQuery.of(context).padding.bottom),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.9),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.accentGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Scanning...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Align the QR code within the frame',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Simulation Button for Quick Testing
                  ElevatedButton.icon(
                    onPressed: _simulateScan,
                    icon: const Icon(Icons.qr_code_scanner_rounded, size: 18),
                    label: const Text('Simulate Scan / Load Voucher'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.goldAccent,
                      foregroundColor: AppColors.deepRoyalPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Scan Overlay ──────────────────────────────────────────────────────────────
class _ScanOverlay extends StatelessWidget {
  final Animation<double> scanLine;
  const _ScanOverlay({required this.scanLine});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth * 0.72;
        final top = (constraints.maxHeight - size) / 2.2;
        final left = (constraints.maxWidth - size) / 2;

        return Stack(
          children: [
            // Target Frame Box
            Positioned(
              top: top,
              left: left,
              width: size,
              height: size,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Stack(
                  children: [
                    // Glowing Corner brackets
                    const _CornerBrackets(),

                    // Animated laser scan line
                    AnimatedBuilder(
                      animation: scanLine,
                      builder: (context, child) {
                        return Positioned(
                          top: scanLine.value * (size - 10),
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 3,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  AppColors.goldAccent,
                                  AppColors.crispWhite,
                                  AppColors.goldAccent,
                                  Colors.transparent,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.goldAccent.withValues(alpha: 0.8),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ── Corner Brackets ───────────────────────────────────────────────────────────
class _CornerBrackets extends StatelessWidget {
  const _CornerBrackets();

  @override
  Widget build(BuildContext context) {
    const cornerSize = 24.0;
    const strokeWidth = 3.5;
    const color = AppColors.goldAccent;

    return Stack(
      children: [
        // Top-left
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            width: cornerSize,
            height: cornerSize,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: color, width: strokeWidth),
                left: BorderSide(color: color, width: strokeWidth),
              ),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16)),
            ),
          ),
        ),
        // Top-right
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            width: cornerSize,
            height: cornerSize,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: color, width: strokeWidth),
                right: BorderSide(color: color, width: strokeWidth),
              ),
              borderRadius: BorderRadius.only(topRight: Radius.circular(16)),
            ),
          ),
        ),
        // Bottom-left
        Positioned(
          bottom: 0,
          left: 0,
          child: Container(
            width: cornerSize,
            height: cornerSize,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: color, width: strokeWidth),
                left: BorderSide(color: color, width: strokeWidth),
              ),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16)),
            ),
          ),
        ),
        // Bottom-right
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: cornerSize,
            height: cornerSize,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: color, width: strokeWidth),
                right: BorderSide(color: color, width: strokeWidth),
              ),
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(16)),
            ),
          ),
        ),
      ],
    );
  }
}

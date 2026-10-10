import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../features/form/models/transaction_model.dart';
import '../../../features/form/providers/form_provider.dart';
import '../../../l10n/app_localizations.dart';

class HistoryScreen extends StatefulWidget {
  final bool embedded;
  const HistoryScreen({super.key, this.embedded = false});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FormProvider>().loadTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<FormProvider>();
    final isDark = provider.isDarkMode;
    final transactions = provider.transactions;

    final body = transactions.isEmpty
        ? _EmptyHistory(isDark: isDark)
        : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: transactions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (ctx, i) => _TransactionCard(
              tx: transactions[i],
              isDark: isDark,
            ),
          );

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F0024) : const Color(0xFFF7F6FA),
      appBar: AppBar(
        backgroundColor: AppColors.deepRoyalPurple,
        elevation: 0,
        title: Text(
          l10n.history,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: () => context.read<FormProvider>().loadTransactions(),
          ),
        ],
      ),
      body: SafeArea(
        child: body,
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  final bool isDark;
  const _EmptyHistory({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1D0047) : const Color(0xFFF3F4F6),
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? Colors.white.withValues(alpha: 0.1) : const Color(0xFFE5E7EB),
              ),
            ),
            child: const Icon(Icons.receipt_long_outlined,
                size: 36, color: Color(0xFF9CA3AF)),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noHistory,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF1E1435),
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              l10n.noHistorySub,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? const Color(0xFFB8A9D4) : const Color(0xFF6B7280),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final TransactionModel tx;
  final bool isDark;

  const _TransactionCard({required this.tx, required this.isDark});

  Color get _statusColor {
    switch (tx.status) {
      case 'completed':
        return const Color(0xFF10B981);
      case 'expired':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFFD97706);
    }
  }

  Color get _typeColor => tx.formType.toLowerCase().contains('deposit') ||
          tx.formType.contains('ገቢ')
      ? const Color(0xFF10B981)
      : const Color(0xFF6D28D9);

  String _formatStatus(String status, AppLocalizations l10n) {
    switch (status) {
      case 'completed':
        return l10n.statusCompleted;
      case 'expired':
        return l10n.statusExpired;
      default:
        return l10n.statusPending;
    }
  }

  String _formatType(String formType, AppLocalizations l10n) {
    if (formType.toLowerCase().contains('deposit') || formType.contains('ገቢ')) {
      return l10n.cashDeposit;
    }
    return l10n.cashWithdrawal;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1D0047) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.12) : const Color(0xFFE5E7EB),
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
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _typeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  tx.formType.toLowerCase().contains('deposit') || tx.formType.contains('ገቢ')
                      ? Icons.arrow_downward_rounded
                      : Icons.arrow_upward_rounded,
                  color: _typeColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatType(tx.formType, l10n),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF1E1435),
                      ),
                    ),
                    Text(
                      tx.referenceNumber,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? const Color(0xFFB8A9D4) : const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _formatStatus(tx.status, l10n).toUpperCase(),
                  style: TextStyle(
                    color: _statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(
            color: isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFF3F4F6),
            height: 1,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${tx.totalAmount.toStringAsFixed(2)} ${isAmharic ? "ብር" : "ETB"}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.goldAccent : const Color(0xFF1E1435),
                ),
              ),
              Text(
                isAmharic
                    ? DateFormat('dd/MM/yyyy').format(tx.createdAt)
                    : DateFormat('dd MMM yyyy').format(tx.createdAt),
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? const Color(0xFFB8A9D4) : const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

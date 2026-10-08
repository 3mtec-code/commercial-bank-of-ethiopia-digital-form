import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import 'custom_button.dart';

// ── Step Bottom Action Bar ─────────────────────────────────────────────────────
class FormBottomBar extends StatelessWidget {
  final VoidCallback onNext;
  final String nextLabel;
  final VoidCallback? onBack;

  const FormBottomBar({
    super.key,
    required this.onNext,
    required this.nextLabel,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: EdgeInsets.fromLTRB(
              20, 12, 20, 12 + MediaQuery.of(context).padding.bottom),
          decoration: BoxDecoration(
            color: const Color(0xFF160036).withValues(alpha: 0.9),
            border: Border(
              top: BorderSide(
                color: Colors.white.withValues(alpha: 0.12),
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: Row(
            children: [
              if (onBack != null) ...[
                Expanded(
                  child: SecondaryButton(
                    label: 'Back',
                    onPressed: onBack,
                    color: AppColors.goldAccent,
                  ),
                ),
                const SizedBox(width: 14),
              ],
              Expanded(
                flex: onBack != null ? 2 : 1,
                child: PrimaryButton(
                  label: nextLabel,
                  onPressed: onNext,
                  gradient: AppColors.goldGradient,
                  textColor: AppColors.deepRoyalPurple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Field Label ────────────────────────────────────────────────────────────────
class FieldLabel extends StatelessWidget {
  final String label;
  final bool required;

  const FieldLabel({super.key, required this.label, this.required = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.crispWhite,
          ),
        ),
        if (required)
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

// ── Styled Text Field ──────────────────────────────────────────────────────────
class StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final int? maxLines;

  const StyledTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.prefixIcon,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.validator,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(
        color: AppColors.crispWhite,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: AppColors.textMuted,
          fontSize: 14,
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.08),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.18),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.18),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.goldAccent,
            width: 1.8,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.8),
        ),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.goldAccent, size: 20)
            : null,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

// ── Section Header ─────────────────────────────────────────────────────────────
class FormSectionHeader extends StatelessWidget {
  final String step;
  final String title;

  const FormSectionHeader({
    super.key,
    required this.step,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.goldAccent.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.goldAccent.withValues(alpha: 0.35),
            ),
          ),
          child: Text(
            step,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.goldAccent,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.crispWhite,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}

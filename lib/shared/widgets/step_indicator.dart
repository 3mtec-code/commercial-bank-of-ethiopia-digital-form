import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> stepLabels;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepLabels,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final stepNum = index + 1;
        final isCompleted = stepNum < currentStep;
        final isActive = stepNum == currentStep;

        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  if (index > 0)
                    Expanded(
                      child: Container(
                        height: 2.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: isCompleted || isActive
                              ? AppColors.goldAccent
                              : Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                    ),
                  _StepCircle(
                    number: stepNum,
                    isCompleted: isCompleted,
                    isActive: isActive,
                  ),
                  if (index < totalSteps - 1)
                    Expanded(
                      child: Container(
                        height: 2.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: isCompleted
                              ? AppColors.goldAccent
                              : Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              if (index < stepLabels.length)
                Text(
                  stepLabels[index],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isActive || isCompleted
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: isActive
                        ? AppColors.goldAccent
                        : isCompleted
                            ? AppColors.crispWhite
                            : AppColors.textMuted,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        );
      }),
    );
  }
}

class _StepCircle extends StatelessWidget {
  final int number;
  final bool isCompleted;
  final bool isActive;

  const _StepCircle({
    required this.number,
    required this.isCompleted,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompleted) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.accentGreen,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.accentGreen.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: Icon(Icons.check_rounded, color: Colors.white, size: 18),
        ),
      );
    }

    if (isActive) {
      return Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          gradient: AppColors.goldGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.goldAccent.withValues(alpha: 0.6),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            '$number',
            style: const TextStyle(
              color: AppColors.deepRoyalPurple,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      );
    }

    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.25),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Text(
          '$number',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

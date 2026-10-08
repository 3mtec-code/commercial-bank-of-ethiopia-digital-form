import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class CbeLogo extends StatelessWidget {
  static const String logoUrl =
      'https://res.cloudinary.com/wv0iyr54/image/upload/v1791448746/Commercial_Bank_of_Ethiopia_Logo_PNG_Vector_AI_Free_Download_eqzdpv.jpg';

  final double size;
  final bool showText;
  final Color? textColor;
  final String? subtitle;

  const CbeLogo({
    super.key,
    this.size = 64,
    this.showText = false,
    this.textColor,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final logoWidget = ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: size,
          height: size,
          padding: EdgeInsets.all(size * 0.1),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.25),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: AppColors.goldAccent.withValues(alpha: 0.1),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: logoUrl,
              fit: BoxFit.contain,
              placeholder: (context, url) => Center(
                child: SizedBox(
                  width: size * 0.4,
                  height: size * 0.4,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.goldAccent),
                  ),
                ),
              ),
              errorWidget: (context, url, error) {
                return Image.asset(
                  'assets/images/cbe_logo.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.goldAccent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'CBE',
                          style: TextStyle(
                            color: AppColors.goldAccent,
                            fontWeight: FontWeight.w900,
                            fontSize: size * 0.28,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );

    if (!showText) {
      return logoWidget;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        logoWidget,
        const SizedBox(height: 10),
        Text(
          'የኢትዮጵያ ንግድ ባንክ',
          style: TextStyle(
            fontSize: size * 0.26,
            fontWeight: FontWeight.w700,
            color: textColor ?? AppColors.crispWhite,
            letterSpacing: 0.5,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: size * 0.18,
              fontWeight: FontWeight.w500,
              color: AppColors.goldAccent,
            ),
          ),
        ],
      ],
    );
  }
}

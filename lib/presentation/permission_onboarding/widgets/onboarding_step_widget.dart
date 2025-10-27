import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OnboardingStepWidget extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String semanticLabel;
  final bool isActive;

  const OnboardingStepWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.semanticLabel,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration Container
          Container(
            width: 80.w,
            height: 35.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              color: AppTheme.surfaceNearBlack,
              border: Border.all(
                color: isActive
                    ? AppTheme.accentCyan.withValues(alpha: 0.3)
                    : AppTheme.dividerColor.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              child: CustomImageWidget(
                imageUrl: imageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                semanticLabel: semanticLabel,
              ),
            ),
          ),

          SizedBox(height: 4.h),

          // Title
          Text(
            title,
            style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 2.h),

          // Description
          Container(
            constraints: BoxConstraints(maxWidth: 85.w),
            child: Text(
              description,
              style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

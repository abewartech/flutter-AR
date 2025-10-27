import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const ProgressIndicatorWidget({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Column(
        children: [
          // Step indicator text
          Text(
            '$currentStep dari $totalSteps',
            style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 1.h),

          // Progress dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalSteps, (index) {
              final isActive = index < currentStep;
              final isCurrent = index == currentStep - 1;

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 1.w),
                child: AnimatedContainer(
                  duration: AppTheme.standardAnimation,
                  width: isCurrent ? 8.w : 2.w,
                  height: 1.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    color: isActive || isCurrent
                        ? AppTheme.accentCyan
                        : AppTheme.dividerColor.withValues(alpha: 0.3),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

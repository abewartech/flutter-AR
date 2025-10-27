import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DetectionStatusWidget extends StatelessWidget {
  final bool isPersonDetected;
  final bool isArMode;
  final int detectionConfidence;

  const DetectionStatusWidget({
    Key? key,
    required this.isPersonDetected,
    required this.isArMode,
    this.detectionConfidence = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 2.h,
      left: 4.w,
      right: 4.w,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 4.w,
          vertical: 1.h,
        ),
        decoration: BoxDecoration(
          color: AppTheme.overlayTransparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isPersonDetected
                ? AppTheme.successGreen.withValues(alpha: 0.3)
                : AppTheme.textSecondary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Status indicator
            Container(
              width: 3.w,
              height: 3.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isPersonDetected
                    ? AppTheme.successGreen
                    : AppTheme.warningAmber,
              ),
            ),
            SizedBox(width: 3.w),
            // Status text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isArMode ? 'Mode AR' : 'Mode Video',
                    style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (isPersonDetected) ...[
                    SizedBox(height: 0.5.h),
                    Text(
                      'Orang terdeteksi (${detectionConfidence}%)',
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.successGreen,
                      ),
                    ),
                  ] else ...[
                    SizedBox(height: 0.5.h),
                    Text(
                      'Mencari orang...',
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Mode icon
            CustomIconWidget(
              iconName: isArMode ? 'view_in_ar' : 'play_circle_filled',
              color: isArMode ? AppTheme.accentCyan : AppTheme.warningAmber,
              size: 6.w,
            ),
          ],
        ),
      ),
    );
  }
}

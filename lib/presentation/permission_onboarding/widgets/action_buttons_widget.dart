import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback onContinue;
  final VoidCallback? onSkip;
  final bool isLastStep;
  final bool isLoading;

  const ActionButtonsWidget({
    Key? key,
    required this.onContinue,
    this.onSkip,
    this.isLastStep = false,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      child: Column(
        children: [
          // Continue/Grant Permission Button
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      HapticFeedback.lightImpact();
                      onContinue();
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentCyan,
                foregroundColor: AppTheme.primaryDark,
                disabledBackgroundColor: AppTheme.dividerColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
              ),
              child: isLoading
                  ? SizedBox(
                      width: 5.w,
                      height: 5.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.primaryDark,
                        ),
                      ),
                    )
                  : Text(
                      isLastStep ? 'Izinkan Akses Kamera' : 'Lanjutkan',
                      style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.primaryDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),

          // Skip button (only show if not last step and skip is available)
          if (!isLastStep && onSkip != null) ...[
            SizedBox(height: 2.h),
            SizedBox(
              width: double.infinity,
              height: 6.h,
              child: TextButton(
                onPressed: isLoading
                    ? null
                    : () {
                        HapticFeedback.selectionClick();
                        onSkip!();
                      },
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.textSecondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                ),
                child: Text(
                  'Lewati',
                  style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

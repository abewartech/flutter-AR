import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PermissionDialogWidget extends StatelessWidget {
  final String title;
  final String description;
  final String primaryButtonText;
  final String? secondaryButtonText;
  final VoidCallback onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;
  final bool isDenied;

  const PermissionDialogWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.primaryButtonText,
    this.secondaryButtonText,
    required this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.isDenied = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.surfaceElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 85.w,
          maxHeight: 60.h,
        ),
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 15.w,
              height: 15.w,
              decoration: BoxDecoration(
                color: isDenied
                    ? AppTheme.errorCoral.withValues(alpha: 0.2)
                    : AppTheme.accentCyan.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              ),
              child: CustomIconWidget(
                iconName: isDenied ? 'warning' : 'camera_alt',
                color: isDenied ? AppTheme.errorCoral : AppTheme.accentCyan,
                size: 8.w,
              ),
            ),

            SizedBox(height: 3.h),

            // Title
            Text(
              title,
              style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 2.h),

            // Description
            Text(
              description,
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 4.h),

            // Action buttons
            Column(
              children: [
                // Primary button
                SizedBox(
                  width: double.infinity,
                  height: 6.h,
                  child: ElevatedButton(
                    onPressed: onPrimaryPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isDenied ? AppTheme.errorCoral : AppTheme.accentCyan,
                      foregroundColor: AppTheme.primaryDark,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMedium),
                      ),
                    ),
                    child: Text(
                      primaryButtonText,
                      style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.primaryDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                // Secondary button
                if (secondaryButtonText != null &&
                    onSecondaryPressed != null) ...[
                  SizedBox(height: 2.h),
                  SizedBox(
                    width: double.infinity,
                    height: 6.h,
                    child: TextButton(
                      onPressed: onSecondaryPressed,
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.textSecondary,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusMedium),
                        ),
                      ),
                      child: Text(
                        secondaryButtonText!,
                        style:
                            AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
